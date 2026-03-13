import { Injectable } from '@nestjs/common';
import { HealthCheckService } from '../healthcheck.service';

@Injectable()
export class HealthService {
  constructor(private readonly healthCheckService: HealthCheckService) {}

  async checkHealth(): Promise<string> {
    return this.healthCheckService.checkHealth();
  }
}
