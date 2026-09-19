# Alcance

> Contrato cerrado en lo esencial.

## Tipo de producto

App **Android (Flutter, APK)** de consulta de infracciones para **agentes de tránsito**. Piloto = padre del promotor. **Sin iOS.**

## MVP

1. Instalar por **APK**  
2. Login **cédula + contraseña + device_id** (usuarios.json híbrido; multi-teléfono)  
3. Listado + filtro por categoría  
4. Búsqueda por código y descripción  
5. Detalle código + descripción  
6. Offline real  
7. Catálogo **híbrido** (seed + sync JSON estático)

### Demo

> APK → login → modo avión → “resonador” → **C.28**.

## Fuera de alcance (v1)

- iOS / Apple Developer / PWA de soporte  
- Play Store / App Store  
- Backend de auth, pagos, SIMIT, IA, multi-rol, campos extra  

## Criterios de éxito

Ver **D-024** y **D-010** en el contrato (piloto encuentra códigos offline; APK real instalado).

## Historias prioritarias

| ID | Como… | Quiero… | Para… | P |
| --- | --- | --- | --- | --- |
| H1–H5 | agente | listar / filtrar / buscar / detalle / offline | comparendo | P0 |
| H6 | agente | login cédula+clave | entrar a su build | P0 |
| H7 | promotor | editar JSON usuarios + APK | personalizar | P1 |
