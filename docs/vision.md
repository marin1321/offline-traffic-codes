# Visión

> Fuente de decisiones: [`../CONTRATO.md`](../CONTRATO.md).

## Problema

El **agente de tránsito**, al elaborar un **comparendo**, necesita el **código de infracción** correcto y su **descripción**, rápido y a menudo **sin internet**.

## Usuarios

| Tipo | Descripción | Necesidad principal | Estado |
| --- | --- | --- | --- |
| Primario (único rol) | **Agente de tránsito** | Buscar código + leer descripción offline | Decidido |
| Piloto | Padre del promotor (Android) | Usar la app en campo | Decidido |
| Fuera de alcance | iPhone, público general, tiendas, multi-rol | — | Decidido |

## Contexto

- **País:** Colombia  
- **Plataforma:** solo **Android** (APK)  
- **Stack:** **Flutter**  
- **Naturaleza:** experimental / personalizada  
- **Catálogo:** híbrido seed + JSON remoto  
- **Legal:** orientación informativa; disclaimer  

## Propuesta de valor

Para **agentes de tránsito** (piloto: un agente en Android) que necesitan el código correcto al armar un comparendo, **Códigos de Tránsito** es una app de **consulta offline** con categorías y búsqueda por código o descripción.

## No-objetivos

- iOS / App Store / Play Store  
- Backend de usuarios / pagos de multas / SIMIT  
- IA  
