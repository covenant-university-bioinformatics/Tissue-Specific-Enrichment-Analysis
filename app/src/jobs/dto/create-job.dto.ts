import {
  IsNumberString,
  IsString,
  MaxLength,
  MinLength,
  IsEnum,
  IsNotEmpty,
  IsEmail,
  IsOptional,
  IsBooleanString,
} from 'class-validator';
import {
  P_ADJUST_METHOD,
  AnalysisType,
  ReferencePanel,
} from '../models/tsea.model';

export class CreateJobDto {
  @IsString()
  @MinLength(5)
  @MaxLength(20)
  job_name: string;

  @IsEmail()
  @IsOptional()
  email: string;

  @IsBooleanString()
  useTest: string;

  @IsNumberString()
  genes: string;

  @IsNotEmpty()
  @IsEnum(AnalysisType)
  analysisType: AnalysisType;

  @IsNotEmpty()
  @IsEnum(ReferencePanel)
  reference_panel: ReferencePanel;

  @IsNumberString()
  ratio: string;

  @IsNotEmpty()
  @IsEnum(P_ADJUST_METHOD)
  p_adjust_method: P_ADJUST_METHOD;

}
