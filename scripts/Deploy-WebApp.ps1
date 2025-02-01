param (
    [string]$appName,
    [string]$environment,
    [string]$resourceGroup,
    [string]$artifactPath,
    [string]$azureSubscription
)

# Function to Deploy Web App
function Start-WebApp {
    param (
        [string]$appName,
        [string]$environment,
        [string]$resourceGroup,
        [string]$artifactPath,
        [string]$azureSubscription
    )

    Write-Output "📦 Starting deployment to $environment environment..."

    # Authenticate with Azure
    Write-Output "🔐 Authenticating with Azure Subscription: $azureSubscription"
    az account set --subscription "$azureSubscription"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Failed to authenticate with Azure."
        exit 1
    }

    # Check if artifact exists
    if (-Not (Test-Path $artifactPath)) {
        Write-Error "❌ Artifact not found at $artifactPath"
        exit 1
    }

    Write-Output "✅ Artifact found: $artifactPath"

    # Deploy to Azure Web App
    Write-Output "🚀 Deploying to $appName in $resourceGroup..."
    az webapp deployment source config-zip --resource-group "$resourceGroup" `
        --name "$appName" --src "$artifactPath"

    if ($LASTEXITCODE -eq 0) {
        Write-Output "✅ Deployment to $environment completed successfully!"
    } else {
        Write-Error "❌ Deployment failed!"
        exit 1
    }
}

# Call the function with parameters
Start-WebApp -appName $appName `
              -environment $environment `
              -resourceGroup $resourceGroup `
              -artifactPath $artifactPath `
              -azureSubscription $azureSubscription
