# Create a base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app
    
# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore
    
# Copy everything else and build
COPY . ./
RUN dotnet build -c Release -o out
RUN dotnet publish --no-build -c Release -o out
    
# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# expose the container to the external port
EXPOSE 80

# command to run to start the application
ENTRYPOINT ["dotnet", "WebApplication1.dll"]