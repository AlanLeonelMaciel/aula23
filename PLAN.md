Implementation Plan: Setup Initial NestJS Project Structure with Clean Architecture and Repository Pattern

**Step 1: Initialize a Barebones NestJS Application**

1. Run the following command in your terminal to initialize a new NestJS project:
   ```bash
npx @nestjs/cli new aula-23-backend
```
2. Follow the prompt to create a new project with the default options.

**Step 2: Define the Core Directory Structure Separating the Layers**

1. Create the following directories in the `src` folder:
   ```bash
src
├── application
├── domain
├── infrastructure
└── presentation
```

2. Update the `package.json` file to reflect the new directory structure:
   ```json
"scripts": {
  "lint": "eslint src/**/*.{ts,tsx}",
  "format": "prettier --write src/**/*.{ts,tsx}",
  "compile": "rimraf dist && tsc"
}
```
3. Rename `src/controllers` to `src/presentation/controllers`:
   ```bash
mv src/controllers src/presentation/controllers
```
4. Rename `src/services` to `src/application/services`:
   ```bash
mv src/services src/application/services
```
5. Rename `src/repositories` to `src/infrastructure/repositories`:
   ```bash
mv src/repositories src/infrastructure/repositories
```
6. Rename `src/entities` to `src/domain/entities`:
   ```bash
mv src/entities src/domain/entities
```

**Step 3: Create a Base Generic Repository Interface (`IRepository`)**

1. Inside the `domain` directory, create a new file called `IRepository.ts`:
   ```bash
src/domain/IRepository.ts
```
   ```typescript
// src/domain/IRepository.ts
export interface IRepository<T> {
  findAll(): Promise<T[]>;
  findById(id: string): Promise<T | null>;
  create(entity: T): Promise<T>;
  update(id: string, entity: T): Promise<T>;
  delete(id: string): Promise<void>;
}
```

**Step 4: Configure Absolute Path Aliases in `tsconfig.json`**

1. In the `tsconfig.json` file, add the following path aliases:
   ```json
// tsconfig.json
{
  "compilerOptions": {
    // ...
    "paths": {
      "@domain/*": ["src/domain/*"],
      "@application/*": ["src/application/*"],
      "@infrastructure/*": ["src/infrastructure/*"],
      "@presentation/*": ["src/presentation/*"]
    }
  }
}
```

**Step 5: Create a Simple "Health Check" Endpoint**

1. Inside the `presentation` directory, create a new file called `health.controller.ts`:
   ```bash
src/presentation/controllers/health/health.controller.ts
```
   ```typescript
// src/presentation/controllers/health/health.controller.ts
import { Controller, Get } from '@nestjs/common';
import { HealthService } from './health.service';

@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  async getHealth(): Promise<string> {
    return 'healthy';
  }
}
```

   ```typescript
// src/presentation/controllers/health/health.service.ts
import { Injectable } from '@nestjs/common';
import { HealthCheckService } from '../healthcheck.service';

@Injectable()
export class HealthService {
  constructor(private readonly healthCheckService: HealthCheckService) {}

  async checkHealth(): Promise<string> {
    return this.healthCheckService.checkHealth();
  }
}
```

   ```typescript
// src/presentation/controllers/health/healthcheck.service.ts
import { Injectable } from '@nestjs/common';

@Injectable()
export class HealthCheckService {
  checkHealth(): Promise<string> {
    return Promise.resolve('healthy');
  }
}
```

2. Add the `HealthController` to the `AppModule`:
   ```typescript
// src/main.module.ts
import { Module } from '@nestjs/common';
import { HealthModule } from './health/health.module';

@Module({
  imports: [HealthModule],
})
export class AppModule {}
```

   ```typescript
// src/health/health.module.ts
import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';

@Module({
  controllers: [HealthController],
  providers: [HealthService],
})
export class HealthModule {}
```

**Step 6: Ensure ESLint and Prettier are Properly Configured**

1. Install the required ESLint and Prettier configurations:
   ```bash
npm install --save-dev eslint prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

2. Create a new file called `.eslintrc.json` with the following configuration:
   ```json
// .eslintrc.json
{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "extends": ["plugin:@typescript-eslint/recommended", "prettier"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "off",
    "@typescript-eslint/no-namespace": "off",
    "@typescript-eslint/no-misused-new": "off",
    "prettier/prettier": "warn",
    "no-console": "off"
  }
}
```

3. Install the ESLint plugin for NestJS:
   ```bash
npm install --save-dev @nestjs/eslint-plugin
```

4. Configure ESLint to use the `@nestjs/eslint-plugin` plugin:
   ```json
// .eslintrc.json
{
  "plugins": ["@nestjs"],
  "extends": ["@nestjs"]
}
```

**Step 7: Verify the NestJS Application Starts Successfully**

1. Run the following command to start the NestJS application:
   ```
nest start
```

2. Verify that the "health check" endpoint returns a `200 OK` status by navigating to `http://localhost:3000/health` in your web browser.

By following these steps, you have successfully set up an initial NestJS project structure with Clean Architecture and the Repository pattern. The project is now configured to use ESLint and Prettier for code quality and formatting, and the health check endpoint is working correctly.
