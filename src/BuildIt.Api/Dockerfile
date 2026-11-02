# syntax=docker/dockerfile:1
# BuildIt.Api — imagen de contenedor para AWS Lambda.
# Contexto de build: raíz del repo.

FROM mcr.microsoft.com/dotnet/sdk:10.0-noble AS build
WORKDIR /build

COPY . .

RUN dotnet restore src/BuildIt.Api/BuildIt.Api.csproj
WORKDIR /build/src/BuildIt.Api
RUN dotnet publish "BuildIt.Api.csproj" -c Release -o /publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0-noble AS final
WORKDIR /app
COPY --from=build /publish .

EXPOSE 8080
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENV ConnectionStrings__DefaultConnection="Server=db;Port=3306;Database=build_it;User=build_it;Password=build_it;"

ENTRYPOINT ["dotnet", "BuildIt.Api.dll"]
