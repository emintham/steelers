require 'error_helper'

class Program < ActiveRecord::Base
  include Dev         # for logging

  # folder_specific is true iff job is LS-DYNA
  # abs_path is a string representing the absolute path of the actual
  #  executable (i.e. not the symbolic link)
  # dyna_type is an attribute defined only for LS-DYNA jobs
  # valid values are 'mpp', 'smp'
  attr_accessible :name, :server_id, :folder_specific, :abs_path, 
    :dyna_type

  # ------------------ Associations ------------------------------------
  has_many :jobs
  belongs_to :server
  has_one :config_template

  # ------------------ Validations -------------------------------------
  validates :name,
    :presence => { :on => :create },
    :uniqueness => true

  # Toggles whether the program is folder-specific (eg. ls-dyna) or not
  # If program is of type LS-DYNA, defaults to mpp type
  def toggle
    update_attribute(:folder_specific, folder_specific ^ true)
    log "Program Model: Toggled #{name}'s folder specificity"
    if folder_specific
      update_attribute(:dyna_type, 'mpp')
      log "Program Model: Changed #{name}'s type to mpp"
    else
      update_attribute(:dyna_type, nil)
      log "Program Model: Changed #{name}'s type to nil"
    end
    return true
  end

  # Changes an LS-DYNA job from dyna_type smp to mpp and vice versa
  def change_type
    if folder_specific      # only defined for LS-DYNA type jobs
      if dyna_type == 'mpp'
        update_attribute(:dyna_type, 'smp')
        log "Program Model: changed #{name} to be of type SMP"
      elsif dyna_type == 'smp'
        update_attribute(:dyna_type, 'mpp')
        log "Program Model: changed #{name} to be of type MPP"
      elsif dyna_type == nil
        update_attribute(:dyna_type, 'mpp')
        log "Program Model: changed #{name} to be of type MPP"
      else
        log "Program Model: #{name} has invalid type: #{dyna_type}"
        return false
      end
      return true
    else
      log "Program Model: attempt to change non-folder-specific job's type"
      return false
    end
  end
end
