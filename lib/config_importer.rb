# Class to import config instances into app given its template
class ConfigImporter
  def initialize(template)
    # import all configuration templates from folder
    @template = template
  end
end
