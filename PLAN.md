Implementation Plan:

**Step 1: Create the Entry Point (`src/main.ts`)**

1. Create a new file `src/main.ts` with the following content:
```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './main.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}

bootstrap();
```
This file imports the `AppModule` and uses the `NestFactory` to create the application instance, which is then bootstrapped to listen on port 3000.

**Step 2: Create the Use Case (`src/application/use-cases/check-health.usecase.ts`)**

1. Create a new file `src/application/use-cases/check-health.usecase.ts` with the following content:
```typescript
import { Injectable } from '@nestjs/common';

@Injectable()
export class CheckHealthUseCase {
  async execute(): Promise<{ status: string; timestamp: string }> {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }
}
```
This file defines a `CheckHealthUseCase` class with an `execute()` method that returns a simple object.

**Step 3: Create the Controller (`src/presentation/health.controller.ts`)**

1. Create a new file `src/presentation/health.controller.ts` with the following content:
```typescript
import { Controller, Get, Inject } from '@nestjs/common';
import { CheckHealthUseCase } from '../application/use-cases/check-health.usecase';

@Controller('health')
export class HealthController {
  constructor(private readonly checkHealthUseCase: CheckHealthUseCase) {}

  @Get()
  async getHealth(): Promise<{ status: string; timestamp: string }> {
    return this.checkHealthUseCase.execute();
  }
}
```
This file defines a `HealthController` class that injects the `CheckHealthUseCase` instance via the constructor. The `@Get()` method calls the `execute()` method of the use case and returns the result.

**Step 4: Update the Root Module (`src/main.module.ts`)**

1. Update the `src/main.module.ts` file to include the `HealthController` and `CheckHealthUseCase` imports:
```typescript
import { Module } from '@nestjs/common';
import { HealthController } from './presentation/controllers/health.controller';
import { CheckHealthUseCase } from './application/use-cases/check-health.usecase';

@Module({
  controllers: [HealthController],
  providers: [CheckHealthUseCase],
})
export class AppModule {}
```
This file imports the `HealthController` and `CheckHealthUseCase` and adds them to the `controllers` and `providers` arrays, respectively.

**Acceptance Criteria:**

* The application can be started and `GET /health` returns a 200 OK with the expected JSON payload: `{ status: 'ok', timestamp: '2023-02-20T14:30:00.000Z' }`.
* The presentation layer (Controller) is strictly decoupled from the logic (Use Case).

Note that this implementation plan assumes a clean architecture structure with separate layers for domain, application, infrastructure, and presentation. The `main.ts` file serves as the entry point for the application, while the `main.module.ts` file defines the root module with the required dependencies. The `HealthController` and `CheckHealthUseCase` classes are decoupled and follow a strict Controller -> Use Case flow.
