require 'spec_helper'

describe Sponsor do
  it { should have_db_column(:name).of_type(:string)           }
  it { should have_db_column(:description).of_type(:text)      }
  it { should have_db_column(:logo_file_name).of_type(:string) }
  it { should have_db_column(:category).of_type(:string)       }
  
  it { should belong_to(:conference) }
end
