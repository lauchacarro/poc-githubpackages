#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["NetCore.Docker.csproj", ""]
RUN dotnet restore "./NetCore.Docker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NetCore.Docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NetCore.Docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NetCore.Docker.dll"]