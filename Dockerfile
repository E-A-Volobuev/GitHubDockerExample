# Базовый образ для сборки
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Восстановление зависимостей (отдельный слой для кэширования)
COPY ["GitHubDockerExample/GitHubDockerExample.csproj", "GitHubDockerExample/"]
RUN dotnet restore "GitHubDockerExample/GitHubDockerExample.csproj"

# Копирование исходников и сборка
COPY . .
RUN dotnet publish "GitHubDockerExample/GitHubDockerExample.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Рантайм-образ
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80
ENTRYPOINT ["dotnet", "GitHubDockerExample.dll"]
