import { Injectable } from '@nestjs/common';

@Injectable()
export class HealthCheckService {
  checkHealth(): Promise<string> {
    return Promise.resolve('healthy');
  }
}
