param (
    [string]$appName,
    [string]$environment,
    [string]$resourceGroup,
    [string]$artifactPath
)

# Function to Deploy Web App
function Start-WebApp {
    param (
        [string]$appName,
        [string]$environment,
        [string]$resourceGroup,
        [string]$artifactPath
    )

    try {
        Write-Output "==========================================="
        Write-Output "Starting deployment to $environment environment..."
        Write-Output "==========================================="

        # Validate Parameters
        if (-not $appName -or -not $resourceGroup -or -not $artifactPath) {
            Write-Error "Missing required parameters."
            exit 1
        }

        # Ensure the Azure CLI is authenticated
        Write-Output "Checking Azure CLI authentication..."
        az account show | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Azure CLI is not authenticated. Please login using 'az login'."
            exit 1
        }

        # Ensure artifact exists
        if (-Not (Test-Path $artifactPath)) {
            Write-Error "Artifact path does not exist: $artifactPath"
            exit 1
        }

        # Deploy to Azure Web App
        Write-Output "Deploying to Azure Web App: $appName"
        az webapp deployment source config-zip `
            --resource-group $resourceGroup `
            --name $appName `
            --src $artifactPath

        if ($LASTEXITCODE -eq 0) {
            Write-Output "✅ Deployment to $environment completed successfully!"
        } else {
            Write-Error "❌ Deployment to $environment failed."
            exit 1
        }
    }
    catch {
        Write-Error "An error occurred: $_"
        exit 1
    }
}

# Execute the deployment
Start-WebApp -appName $appName -environment $environment -resourceGroup $resourceGroup -artifactPath $artifactPath
