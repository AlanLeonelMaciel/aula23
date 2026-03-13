## Step 1: Initialize a Barebones NestJS Application
To start, we'll create a new NestJS application using the Nest CLI. This will give us a basic structure to build upon.

```bash
npm i -g @nestjs/cli
nest new aula-23-backend
```

## Step 2: Define the Core Directory Structure
According to Clean Architecture principles, we need to separate our application into layers. The primary layers are:
- `domain`: Contains the business logic and entities of the application.
- `application`: Handles the use cases and interfaces with the domain layer.
- `infrastructure`: Deals with external frameworks and libraries, including the database.
- `presentation` (or `api`): Exposes the API endpoints.

Let's create these folders within our project:

```plaintext
src
├── domain
├── application
├── infrastructure
├── presentation
```

And move the existing files into their respective layers. For a basic setup, we can consider the following initial move:

- `entities` goes into `domain`
- `services` goes into `application`
- `repositories` goes into `infrastructure`
- `controllers` goes into `presentation`

However, since we're starting from scratch, we'll adjust these as we progress.

## Step 3: Create a Base Generic Repository Interface (IRepository)
In the `domain` layer, we'll define a generic repository interface. This interface will be used by all repositories in the `infrastructure` layer to ensure consistency and abstraction.

Create a file `src/domain/repositories/repository.interface.ts`:

```typescript
export interface IRepository<T> {
  findAll(): Promise<T[]>;
  findOne(id: number): Promise<T | null>;
  create(entity: T): Promise<T>;
  update(id: number, entity: T): Promise<T | null>;
  remove(id: number): Promise<void>;
}
```

## Step 4: Configure Absolute Path Aliases in `tsconfig.json`
To simplify imports across the application, we'll configure path aliases in `tsconfig.json`. This allows us to use `@domain/*`, `@application/*`, etc., for imports.

Update `tsconfig.json` to include the following:

```json
{
  "compilerOptions": {
    // ... existing options
    "baseUrl": "./",
    "paths": {
      "@domain/*": ["src/domain/*"],
      "@application/*": ["src/application/*"],
      "@infrastructure/*": ["src/infrastructure/*"],
      "@presentation/*": ["src/presentation/*"]
    }
  }
}
```

## Step 5: Create a Simple "Health Check" Endpoint
To verify that the application compiles and runs correctly, we'll create a simple "Health Check" endpoint in the `presentation` layer.

Create a `HealthController` in `src/presentation/controllers/health.controller.ts`:

```typescript
import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  healthCheck(): string {
    return 'OK';
  }
}
```

And a `HealthModule` in `src/presentation/modules/health.module.ts` to register the controller:

```typescript
import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';

@Module({
  controllers: [HealthController],
})
export class HealthModule {}
```

Then, import this module into the main `AppModule` in `src/app.module.ts`:

```typescript
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { HealthModule } from '@presentation/modules/health.module';

@Module({
  imports: [HealthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
```

## Step 6: Ensure ESLint and Prettier Are Properly Configured
For code quality and formatting, we'll configure ESLint and Prettier. First, install the necessary packages:

```bash
npm install --save-dev eslint @nestjs/eslint-config prettier
```

Then, create a `.eslintrc.json` file with the following content:

```json
{
  "root": true,
  "ignorePath": ".eslintignore",
  "extends": ["@nestjs/core"],
  "plugins": ["prettier"],
  "rules": {
    "@typescript-eslint/ban-ts-comment": "off",
    "@typescript-eslint/explicit-function-return-type": "off",
    "prettier/prettier": "error"
  }
}
```

And a `.prettierrc.json` for Prettier configuration:

```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "bracketSpacing": true,
  "jsxBracketSameLine": true,
  "arrowParens": "always",
  "proseWrap": "preserve"
}
```

Add scripts to your `package.json` for linting and formatting:

```json
"scripts": {
  // ... other scripts
  "lint": "eslint \"src/**/*.ts\" --fix",
  "prettier": "prettier --write \"src/**/*.ts\""
}
```

## Step 7: Verify the Application
Start the application with `nest start` and navigate to `http://localhost:3000/health` to see the "OK" response, indicating that the health check endpoint is working correctly.

### Conclusion
We've successfully set up a NestJS project with Clean Architecture and the Repository pattern. This structure ensures a clear separation of concerns, making the codebase scalable, testable, and independent of external frameworks.

Remember to run `npm run lint` and `npm run prettier` regularly to maintain code quality and consistency.

### Acceptance Criteria
- The NestJS application starts successfully without any compilation errors.
- The folder structure clearly enforces Clean Architecture boundaries.
- Path aliases are working correctly across all layers.
- The health check endpoint returns a `200 OK` status.

By following these steps, we've met all the acceptance criteria, and the project is now ready for further development.
