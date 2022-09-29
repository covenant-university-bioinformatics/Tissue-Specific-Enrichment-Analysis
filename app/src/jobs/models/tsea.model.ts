import * as mongoose from 'mongoose';

export enum P_ADJUST_METHOD {
  HOLM = 'holm',
  HOCHBERG = 'hochberg',
  HOMMEL = 'hommel',
  BONFERRONI = 'bonferroni',
  BH = 'BH',
  BY = 'BY',
  FDR = 'fdr',
  NONE = 'none'
}

export enum AnalysisType {
  SINGLE_SAMPLE = 'single_sample',
  MULTIPLE_SAMPLES = 'multiple_samples',
  RNA_Seq_profiles = 'RNA_Seq_profiles',
}

export enum ReferencePanel {
  GTEx_t_score = 'GTEx_t_score',
  ENCODE_z_score = 'ENCODE_z_score',
}

//Interface that describe the properties that are required to create a new job
interface TseaAttrs {
  job: string;
  useTest: string;
  genes: string;
  analysisType: AnalysisType;
  reference_panel: ReferencePanel;
  ratio: string;
  p_adjust_method: P_ADJUST_METHOD;
}

// An interface that describes the extra properties that a eqtl model has
//collection level methods
interface TseaModel extends mongoose.Model<TseaDoc> {
  build(attrs: TseaAttrs): TseaDoc;
}

//An interface that describes a properties that a document has
export interface TseaDoc extends mongoose.Document {
  id: string;
  version: number;
  useTest: boolean;
  genes: number;
  analysisType: AnalysisType;
  reference_panel: ReferencePanel;
  ratio: number;
  p_adjust_method: P_ADJUST_METHOD;
}

const TseaSchema = new mongoose.Schema<TseaDoc, TseaModel>(
  {
    useTest: {
      type: Boolean,
      trim: true,
    },
    genes: {
      type: Number,
      trim: true,
    },
    analysisType: {
      type: String,
      enum: [...Object.values(AnalysisType)],
      trim: true,
    },
    reference_panel: {
      type: String,
      enum: [...Object.values(ReferencePanel)],
      trim: true,
    },
    ratio: {
      type: Number,
      trim: true,
    },
    p_adjust_method: {
      type: String,
      enum: [...Object.values(P_ADJUST_METHOD)],
      trim: true,
    },
    job: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'TseaJob',
      required: true,
    },
    version: {
      type: Number,
    },
  },
  {
    timestamps: true,
    versionKey: 'version',
    toJSON: {
      transform(doc, ret) {
        ret.id = ret._id;
        // delete ret._id;
        // delete ret.__v;
      },
    },
  },
);

//increments version when document updates
TseaSchema.set('versionKey', 'version');

//collection level methods
TseaSchema.statics.build = (attrs: TseaAttrs) => {
  return new TseaModel(attrs);
};

//create mongoose model
const TseaModel = mongoose.model<TseaDoc, TseaModel>(
  'Tsea',
  TseaSchema,
  'tseadb',
);

export { TseaModel };
