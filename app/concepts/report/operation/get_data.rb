class Report::GetData < Trailblazer::Operation
  step :find_params

  def find_cpet_params(options, cpet_file:, **)
    cpet_params_cols = {t: 0, vo2: 0, vco: 0, }
  end
  
end