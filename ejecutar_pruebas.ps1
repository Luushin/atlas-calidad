$loginRes = Invoke-RestMethod -Uri "http://localhost:4450/autenticacion/login" -Method Post -ContentType "application/json" -Body '{"nombre_usuario":"admin","password":"admin"}'
$token = $loginRes.token
$headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }

Write-Host "--- LOGIN OK, EJECUTANDO PRUEBAS ---" -ForegroundColor Green

$casos = @(
    @{ id = "TC-CLI-02"; data = @{ nombre="Cliente Prueba 2"; tipo_documento="Pasaporte"; documento="P1234567"; pais="Extranjero"; forma_registro="Manual"; correo="cliente2@prueba.cl" } },
    @{ id = "TC-CLI-03"; data = @{ nombre="Cliente Prueba 3"; tipo_documento="Pasaporte"; documento="P7654321"; pais="Chile"; forma_registro="Carga masiva"; correo="cliente3@prueba.cl" } },
    @{ id = "TC-CLI-04"; data = @{ nombre="Cliente Prueba 4"; tipo_documento="RUT"; documento="22222222-2"; pais="Extranjero"; forma_registro="Carga masiva"; correo="cliente4@prueba.cl" } },
    @{ id = "TC-CLI-N1"; data = @{ tipo_documento="RUT"; documento="33333333-3"; pais="Chile"; forma_registro="Manual"; correo="sinnombre@prueba.cl" } },
    @{ id = "TC-CLI-N2"; data = @{ nombre="Cliente Duplicado"; tipo_documento="RUT"; documento="44444444-4"; pais="Chile"; forma_registro="Manual"; correo="cliente1@prueba.cl" } }
)

foreach ($c in $casos) {
    Write-Host "`n>> Ejecutando $($c.id)..." -ForegroundColor Cyan
    $json = $c.data | ConvertTo-Json
    try {
        $res = Invoke-RestMethod -Uri "http://localhost:4450/clientes" -Method Post -Headers $headers -Body $json
        Write-Host "Resultado: OK (201/200) - Creado" -ForegroundColor Green
        $res | Format-List
    } catch {
        Write-Host "Resultado: ERROR (Esperado en N1 y N2)" -ForegroundColor Yellow
        Write-Host $_.Exception.Message
    }
}
