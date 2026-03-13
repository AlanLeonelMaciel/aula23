# Repository Memory

**Updated Memory Document**

## Technical Knowledge

### Clean Architecture with Repository Pattern

The project structure has been updated to include the Clean Architecture layers:

* `domain`: Contains the business logic and entities of the application.
* `application`: Handles the use cases and interfaces with the domain layer.
* `infrastructure`: Deals with external frameworks and libraries, including the database.
* `presentation`: Exposes the API endpoints.

### NestedJS

* The project uses the `@nestjs/core` module for NestJS configuration.
* The `HealthController` has been added to the `presentation` layer.
* The `HealthService` has been added to the `application` layer.

### ESLint and Prettier

* The project uses ESLint for code quality and formatting.
* A `.eslintrc.json` file has been created to configure ESLint rules.
* A `.prettierrc.json` file has been created to configure Prettier options.
* Scripts have been added to the `package.json` file for linting and formatting.

### Path Aliases

* Path aliases have been added to the `tsconfig.json` file to simplify imports across layers.

## Recent Code Changes

### Folder Structure

* The project structure has been updated to reflect the Clean Architecture layers.
* Existing files have been moved to their respective layers.

### Controllers

* A `HealthController` has been added to the `presentation` layer.
* The `HealthController` has a `getHealth` method that returns a `200 OK` status.

### Services

* A `HealthService` has been added to the `application` layer.
* The `HealthService` has a `checkHealth` method that calls the `HealthCheckService`.

### Health Check Service

* A `HealthCheckService` has been added to the `presentation` layer.
* The `HealthCheckService` has a `checkHealth` method that returns a `200 OK` status.

## Updated Folders

* `src/domain/IRepository.ts`: A new interface for repositories has been created.
* `src/health/health.module.ts`: A new module for the health check service has been created.
* `src/main.module.ts`: The `HealthModule` has been added to the `AppModule`.
* `src/presentation/controllers/health/health.controller.ts`: A new controller for health checks has been created.
* `src/presentation/controllers/health/health.service.ts`: A new service for health checks has been created.
* `src/presentation/controllers/health/healthcheck.service.ts`: A new service for health checks has been created.

## Updated Package.json

* Scripts have been added to the `package.json` file for linting and formatting.

## Updated Tsconfig.json

* Path aliases have been added to the `tsconfig.json` file to simplify imports across layers.

Full updated memory document:

```json
{
  "language": "TypeScript",
  "framework": "NestJS",
  "architecture": "Clean Architecture with Repository Pattern",
  "folders": [
    {
      "name": "domain",
      "description": "Contains the business logic and entities of the application."
    },
    {
      "name": "application",
      "description": "Handles the use cases and interfaces with the domain layer."
    },
    {
      "name": "infrastructure",
      "description": "Deals with external frameworks and libraries, including the database."
    },
    {
      "name": "presentation",
      "description": "Exposes the API endpoints."
    }
  ],
  "testing": {
    "framework": "Jest",
    "type": "Unit Tests"
  },
  "rules": {
    "Controllers must be thin": true,
    "Business logic in services": true,
    "Repositories handle DB access": true,
    "Models in the entities": true
  },
  "pathAliases": {
    "@domain/*": "src/domain/*",
    "@application/*": "src/application/*",
    "@infrastructure/*": "src/infrastructure/*",
    "@presentation/*": "src/presentation/*"
  },
  "technicalKnowledge": [
    "Clean Architecture with Repository Pattern",
    "NestJS",
    "ESLint and Prettier",
    "Path Aliases"
  ],
  "recentCodeChanges": [
    "Folder structure updated to reflect Clean Architecture layers",
    "HealthController added to presentation layer",
    "HealthService added to application layer",
    "HealthCheckService added to presentation layer",
    "HealthModule added to AppModule"
  ],
  "updatedFolders": [
    "src/domain/IRepository.ts",
    "src/health/health.module.ts",
    "src/main.module.ts",
    "src/presentation/controllers/health/health.controller.ts",
    "src/presentation/controllers/health/health.service.ts",
    "src/presentation/controllers/health/healthcheck.service.ts"
  ],
  "updatedPackageJson": {
    "scripts": {
      "lint": "eslint src/**/*.{ts,tsx}",
      "format": "prettier --write src/**/*.{ts,tsx}",
      "compile": "rimraf dist && tsc"
    }
  },
  "updatedTsconfigJson": {
    "compilerOptions": {
      "baseUrl": "./",
      "paths": {
        "@domain/*": ["src/domain/*"],
        "@application/*": ["src/application/*"],
        "@infrastructure/*": ["src/infrastructure/*"],
        "@presentation/*": ["src/presentation/*"]
      }
    }
  }
}
```

Note that this is a condensed version of the updated memory document. The original document is provided in the snippet above.
