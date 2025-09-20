# terraformTest01
Prueba de Terraform para arquitectura simple

# Indicaciones de instalación y ejecución
Paso 1: Pre requisitos
Sistema operativo: Terraform funciona en Windows, Linux y macOS.
Visual Studio Code (VS Code).
Git instalado (opcional pero recomendable).
Cuenta en la nube (ej: Azure, AWS, GCP) (no necesaria para la prueba rápida.)

Paso 2: Instalar Terraform
Windows 64-bit
Ve a la página oficial: Terraform Downloads
Descarga el binario de Windows (64-bit).
Extrae el .zip en una carpeta, por ejemplo: C:\tools\terraform
Agrega esa carpeta al PATH:
- Abre Panel de Control → Sistema → Configuración avanzada → Variables de entorno.
- En "Path" añade C:\tools\terraform.
Verifica instalación: abre PowerShell o CMD y ejecuta:
``` terraform -versión ```

Linux / macOS
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
Verifica
``` terraform -version ```

Paso 3: Configurar VS Code
Abre VS Code.
Instala la extensión oficial HashiCorp Terraform desde el Marketplace.
(Opcional) Instala la extensión Terraform Prettify para formatear el código.

Paso 4: Crear un proyecto Terraform de prueba
main.tf

Paso 5: Ejecutar comandos Terraform
En la terminal de VS Code (dentro de la carpeta del proyecto):
Inicializar proyecto (descarga plugins):
``` terraform init ```
Ver plan de ejecución:
``` terraform plan ```
(Opcional y debes estar conectado a tu cuenta de nube, por ejemplo Azure) Aplicar cambios:
``` terraform apply ```
Actualizar las versiones del proveedor y del módulo.
``` terraform init -upgrade ```

Paso 6: Pasos para instalar Azure CLI en Windows:
Descarga el instalador desde: https://learn.microsoft.com/es-es/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=winget
Ejecuta el instalador y sigue las instrucciones.
Verifica la instalación en la terminal de VS Code con:
``` az --version ```
Inicia sesión en Azure:
``` az login ```
