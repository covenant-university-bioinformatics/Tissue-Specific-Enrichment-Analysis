import * as mongoose from 'mongoose';
import { UserDoc } from '../../auth/models/user.model';
import { TseaDoc } from './tsea.model';

export enum JobStatus {
  COMPLETED = 'completed',
  RUNNING = 'running',
  FAILED = 'failed',
  ABORTED = 'aborted',
  NOTSTARTED = 'not-started',
  QUEUED = 'queued',
}

//Interface that describe the properties that are required to create a new job
interface JobsAttrs {
  jobUID: string;
  job_name: string;
  status: JobStatus;
  user?: string;
  email?: string;
  inputFile: string;
  longJob: boolean;
}

// An interface that describes the extra properties that a model has
//collection level methods
interface JobsModel extends mongoose.Model<TseaJobsDoc> {
  build(attrs: JobsAttrs): TseaJobsDoc;
}

//An interface that describes a properties that a document has
export interface TseaJobsDoc extends mongoose.Document {
  id: string;
  jobUID: string;
  job_name: string;
  inputFile: string;
  status: JobStatus;
  user?: UserDoc;
  email?: string;
  failed_reason: string;
  longJob: boolean;
  tsea_params: TseaDoc;
  tseaResultsFile: string;
  version: number;
  completionTime: Date;
}

const TseaJobSchema = new mongoose.Schema<TseaJobsDoc, JobsModel>(
  {
    jobUID: {
      type: String,
      required: [true, 'Please add a Job UID'],
      unique: true,
      trim: true,
    },
    job_name: {
      type: String,
      required: [true, 'Please add a name'],
    },
    inputFile: {
      type: String,
      required: [true, 'Please add a input filename'],
      trim: true,
    },
    tseaResultsFile: {
      type: String,
      trim: true,
    },
    failed_reason: {
      type: String,
      trim: true,
    },
    status: {
      type: String,
      enum: [
        JobStatus.COMPLETED,
        JobStatus.NOTSTARTED,
        JobStatus.RUNNING,
        JobStatus.FAILED,
        JobStatus.ABORTED,
        JobStatus.QUEUED,
      ],
      default: JobStatus.NOTSTARTED,
    },
    longJob: {
      type: Boolean,
      default: false,
    },
    completionTime: {
      type: Date,
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      // required: true,
    },
    email: {
      type: String,
      trim: true,
    },
    version: {
      type: Number,
    },
  },
  {
    timestamps: true,
    versionKey: 'version',
    toObject: { virtuals: true },
    toJSON: {
      virtuals: true,
      transform(doc, ret) {
        ret.id = ret._id;
        // delete ret._id;
        // delete ret.__v;
      },
    },
  },
);

//increments version when document updates
// jobsSchema.set("versionKey", "version");

//collection level methods
TseaJobSchema.statics.build = (attrs: JobsAttrs) => {
  return new TseaJobsModel(attrs);
};

//Cascade delete main job parameters when job is deleted
TseaJobSchema.pre('remove', async function (next) {
  console.log('Job parameters being removed!');
  await this.model('Tsea').deleteMany({
    job: this.id,
  });
  next();
});

//reverse populate jobs with main job parameters
TseaJobSchema.virtual('tsea_params', {
  ref: 'Tsea',
  localField: '_id',
  foreignField: 'job',
  required: true,
  justOne: true,
});

TseaJobSchema.set('versionKey', 'version');

//create mongoose model
const TseaJobsModel = mongoose.model<TseaJobsDoc, JobsModel>(
  'TseaJob',
  TseaJobSchema,
  'tseajobs',
);

export { TseaJobsModel };
