import { Global, Module } from '@nestjs/common';
import { JobsTseaService } from './services/jobs.tsea.service';
import { JobsTseaController } from './controllers/jobs.tsea.controller';
import { QueueModule } from '../jobqueue/queue.module';
import { JobsTseaNoauthController } from './controllers/jobs.tsea.noauth.controller';

@Global()
@Module({
  imports: [QueueModule],
  controllers: [JobsTseaController, JobsTseaNoauthController],
  providers: [JobsTseaService],
  exports: [],
})
export class JobsModule {}
