# Reflexión Técnica — Lab 8: IaC con Terraform en Azure

## Decisiones de diseño

### Arquitectura modular
Se optó por dividir la infraestructura en tres módulos independientes (`vnet`, `compute`, `lb`), siguiendo el principio de responsabilidad única. Esto permite reutilizar, versionar y probar cada módulo por separado. El módulo raíz (`infra/`) actúa como orquestador que ensambla las piezas.

### L4 Load Balancer vs Application Gateway (L7)
Se eligió **Azure Load Balancer Standard (L4)** porque el laboratorio expone una única aplicación HTTP sin necesidad de enrutamiento basado en rutas o cabeceras. Un Application Gateway (L7) añadiría terminación TLS, WAF y path-based routing, capacidades valiosas en producción pero innecesarias aquí. El trade-off es costo (~$0.025/hora LB Standard vs ~$0.246/hora App Gateway v2) y complejidad operacional.

### Backend remoto con Azure Storage
El estado de Terraform se almacena en Azure Blob Storage con **state locking** habilitado automáticamente (el provider azurerm usa leases de blob). Esto evita que dos ingenieros apliquen cambios simultáneamente y corrompen el estado. Alternativa descartada: estado local (no colaborativo, se pierde si se borra el repo).

### Autenticación OIDC en GitHub Actions
En lugar de guardar un `ARM_CLIENT_SECRET` como secreto de GitHub (que expira, puede filtrarse y requiere rotación), se usa **federación de identidades OIDC**: GitHub emite un token JWT firmado que Azure valida directamente. El beneficio principal es que no hay secretos de larga duración almacenados.

### SSH por clave, no por contraseña
La VM se configura con `disable_password_authentication = true`. La clave pública se pasa como variable (no hardcodeada), lo que impide que esté en el repositorio. En el pipeline, la clave pública se almacena como secreto de GitHub.

---

## Trade-offs observados

| Decisión | Ventaja | Desventaja |
|---|---|---|
| Standard_B1s para VMs | Bajo costo (~$8/mes) | Sin SLA de CPU (burstable) |
| NSG en NICs, no en subnet | Más granular | Más reglas que mantener |
| 2 VMs fijas | Simple de entender | No escala automáticamente |
| cloud-init en lugar de Ansible | Sin dependencias externas | Menos potente para configs complejas |

---

## Estimación de costos (eastus, ~8h de uso en el lab)

| Recurso | Precio/hora | Costo lab (8h) |
|---|---|---|
| 2× VM Standard_B1s | $0.0104 c/u | ~$0.17 |
| Load Balancer Standard | $0.025 | ~$0.20 |
| IP Pública estática | $0.004 | ~$0.03 |
| Storage Account (state) | despreciable | <$0.01 |
| **Total estimado** | | **~$0.41** |

---

## Cómo destruir de forma segura

1. Verificar que no haya dependencias externas apuntando a la IP del LB.
2. Ejecutar localmente:
   ```bash
   cd infra
   terraform destroy -var-file=env/dev.tfvars
   ```
   O desde GitHub Actions: `workflow_dispatch` → seleccionar `destroy`.
3. Confirmar que el Resource Group `lab8-rg` ya no existe:
   ```bash
   az group show -n lab8-rg
   ```
4. El Storage Account del state **no** se destruye con este comando (es externo al state). Eliminarlo manualmente si ya no se necesita:
   ```bash
   az group delete -n rg-tfstate-lab8 --yes
   ```

---

## Mejoras para producción

- **VM Scale Set** con autoescalado basado en métricas de CPU/requests.
- **Azure Bastion** para eliminar la exposición de puerto 22 a Internet.
- **Application Gateway + WAF** para protección L7 y terminación TLS.
- **Azure Monitor + Alertas** sobre el estado del health probe.
- **Budget Alert** para cortar el gasto si supera un umbral.
- Módulos versionados en un **Terraform Registry privado** con semantic versioning.
