@echo off
for /f "tokens=* delims=" %%F in ('curl.exe -s -X POST "http://localhost:4450/autenticacion/login" -H "Content-Type: application/json" -d "{\"nombre_usuario\":\"admin\",\"password\":\"admin\"}"') do set RESP=%%F
for /f "tokens=2 delims=:, " %%T in ('echo %%RESP%% ^| findstr /i "token"') do set TOKEN=%%~T
echo Token obtenido con exito.
echo Ejecutando TC-CLI-02...
curl.exe -i -X POST "http://localhost:4450/clientes" -H "accept: application/json" -H "Authorization: Bearer %%TOKEN%%" -H "Content-Type: application/json" -d "{\"nombre\":\"Cliente Prueba 2\",\"tipo_documento\":\"Pasaporte\",\"documento\":\"P1234567\",\"pais\":\"Extranjero\",\"forma_registro\":\"Manual\",\"correo\":\"cliente2@prueba.cl\"}"
