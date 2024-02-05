# Pegar o nome do projeto do arquivo package.json
$NOME_DO_PROJETO = (Get-Content ./package.json | ConvertFrom-Json).name

# Substituir - por espaço e colocar palavras em iniciais maiúsculas
$NOME_DO_PROJETO = $NOME_DO_PROJETO -replace '-', ' ' -split ' ' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }

# Apagar tudo dentro da pasta public
Remove-Item -Path .\public\* -Recurse -Force

# Verificar se a pasta src/assets existe e, se existir, apagar tudo dentro dela
if (Test-Path .\src\assets) {
    Remove-Item -Path .\src\assets\* -Recurse -Force
}

# Criar as pastas /src/components, /src/pages, /src/contexts
$srcFolders = @("components", "pages", "contexts")

foreach ($folder in $srcFolders) {
    $path = ".\src\$folder"
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory
    }
}

Write-Host "Estrutura de pastas consertada"

# Limpar o conteúdo de src/index.css e acrescentar a linha "@import url('https://renan-santos.netlify.app/styles/reset.css');"
"@import url('https://renan-santos.netlify.app/styles/reset.css');" | Out-File -FilePath .\src\index.css
Write-Host "reset.css importado"

# Apagar os arquivos src/App.css e src/App.jsx
Remove-Item -Path .\src\App.css -Force
Remove-Item -Path .\src\App.jsx -Force

# Criar o arquivo src/router.jsx
@"
export default function Router() {
  return (
    <>
      
    </>
  );
}
"@ | Out-File -FilePath .\src\router.jsx
Write-Host "router criado"

# Trocar o conteúdo de src/main.jsx
@"
import React from 'react'
import ReactDOM from 'react-dom/client'
import Router from './router.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <Router />
  </React.StrictMode>,
)
"@ | Out-File -FilePath .\src\main.jsx
Write-Host "main.jsx modificado"

# Trocar o conteúdo de index.html
@"
<!doctype html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <link rel="icon" href="favicon.svg" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="author" content="Renan Santos" />
  <title>$NOME_DO_PROJETO</title>
  <meta name="description" content="">
</head>
<body>
  <noscript>Este App só pode ser visualizado se você habilitar o JavaScript no navegador.</noscript>
  <div id="root"></div>
  <script type="module" src="/src/main.jsx"></script>
</body>
</html>
"@ | Out-File -FilePath .\index.html
Write-Host "index.html consertado"

# Instalar as dependências
npm install --save `
  "@fortawesome/fontawesome-svg-core" `
  "@fortawesome/free-solid-svg-icons" `
  "@fortawesome/free-regular-svg-icons" `
  "@fortawesome/free-brands-svg-icons" `
  "@fortawesome/react-fontawesome" `
  "react-router-dom" `
  "react-router-hash-link"
Write-Host "dependências instaladas"


git init
git branch -M main
git add .
git commit -m 'commit inicial'
Write-Host "Repositório git iniciado"

# Avisar ao usuário que o script foi concluído
Write-Host "Script concluído!"