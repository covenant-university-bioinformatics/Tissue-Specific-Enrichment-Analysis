import { Inject, Module, OnModuleInit } from '@nestjs/common';
import { createWorkers } from '../workers/tsea.main';
import { TseaJobQueue } from './queue/tsea.queue';
import { NatsModule } from '../nats/nats.module';
import { JobCompletedPublisher } from '../nats/publishers/job-completed-publisher';

@Module({
  imports: [NatsModule],
  providers: [TseaJobQueue],
  exports: [TseaJobQueue],
})
export class QueueModule implements OnModuleInit {
  @Inject(JobCompletedPublisher) jobCompletedPublisher: JobCompletedPublisher;
  async onModuleInit() {
    await createWorkers(this.jobCompletedPublisher);
  }
}
