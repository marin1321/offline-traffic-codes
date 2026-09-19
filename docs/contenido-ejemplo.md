# Contenido de ejemplo (muestra de forma)

> Tramo aportado en la definición de producto (2026-09-19).  
> Sirve como **referencia de estructura y tono**, no como catálogo oficial completo.  
> La fuente formal y el catálogo íntegro se cierran en **D-023**.

## A — Vehículos no automotores

| Código | Descripción |
| --- | --- |
| A.01 | No transitar por la derecha de la vía. |
| A.02 | Agarrarse de otro vehículo en movimiento. |
| A.03 | Transportar personas o cosas que reduzcan la visibilidad o incomoden la conducción. |
| A.04 | Transitar por andenes, aceras, puentes u otros lugares destinados a peatones. |
| A.05 | No respetar las señales de tránsito. |
| A.06 | Transitar sin los dispositivos luminosos requeridos. |

## B — Conductor / propietario

| Código | Descripción |
| --- | --- |
| B.01 | Conducir sin llevar consigo la licencia de conducción. |
| B.03 | Conducir sin placas, con placas que no puedan identificarse correctamente o alterar características de identificación del vehículo. |
| B.04 | Conducir con placas adulteradas, retocadas o alteradas. |
| B.06 | Conducir con placas falsas. |
| B.08 | No pagar el peaje en los sitios establecidos. |
| B.10 | Conducir con vidrios polarizados/entintados sin el permiso correspondiente. |

## C — Infracciones de mayor cuantía ordinaria

| Código | Descripción |
| --- | --- |
| C.01 | Presentar licencia de conducción adulterada o ajena. |
| C.02 | Estacionar en lugares prohibidos, como andenes, zonas verdes, ciertos cruces, puentes, etc. |
| C.06 | No utilizar el cinturón de seguridad en los casos exigidos. |
| C.07 | No señalizar adecuadamente giros, cambios de carril o reducciones de velocidad. |
| C.14 | Transitar por sitios restringidos o en condiciones prohibidas para determinados vehículos. |
| C.24 | Conducir motocicleta sin observar determinadas normas de circulación y seguridad establecidas para estos vehículos. |
| C.26 | Transitar con vehículos de 3,5 toneladas o más por el carril izquierdo cuando haya más de un carril. |
| C.27 | Llevar carga o pasajeros de manera que obstruyan la visibilidad o el control del vehículo. |
| C.28 | Usar resonadores, dispositivos productores de ruido, cornetas en perímetro urbano, sirenas o luces reservadas, o circular sin silenciador en correcto estado. |
| C.29 | Conducir a una velocidad superior a la máxima permitida. |
| C.30 | No atender una señal de CEDA EL PASO. |
| C.31 | No acatar señales de tránsito o requerimientos de agentes de tránsito. |
| C.32 | No respetar el paso o prelación de los peatones en los lugares establecidos. |
| C.35 | No realizar la revisión técnico-mecánica y de emisiones en los plazos establecidos, o no cumplir las condiciones técnico-mecánicas exigidas. |
| C.38 | Usar teléfonos o sistemas móviles de comunicación mientras se conduce, salvo los sistemas que permitan utilizarlos con las manos libres. |
| C.39 | Vulnerar las reglas de estacionamiento establecidas en el artículo 77. |

## Notas para búsqueda (borrador, no decidido)

Ejemplos de **keywords** que podrían curarse más adelante (D-030):

| Código | Keywords posibles |
| --- | --- |
| C.28 | resonador, ruido, corneta, sirena, silenciador, escape |
| C.38 | celular, teléfono, móvil, manos libres, WhatsApp |
| C.06 | cinturón, cinturon, seatbelt |
| C.35 | tecnomecánica, RTM, gases, revisión |

La decisión de si los keywords van curados a mano o solo se indexa `descripcion` sigue abierta en el contrato.


## Campo `referencias` (artículos / resoluciones)

Lista opcional de normas asociadas al código. Se muestra en el **detalle** al tocar la infracción.

Ejemplo en JSON:

```json
"referencias": ["Art. 131", "Res. 20"]
```

| Código (muestra) | Referencias de ejemplo en el seed |
| --- | --- |
| C.28 | Art. 131, Res. 20 |
| C.38 | Art. 131, Ley 1696 |
| C.06 | Art. 82 |

Los valores reales los completa el promotor al curar el catálogo.
