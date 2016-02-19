require 'spec_helper'
require 'puppet/pops'
require 'puppet/loaders'

describe 'rhn_keys' do

  let(:reg_map) do
    {
      'rhel6' => '12393828293',
      'physical' => '128283828',
      'vmware'   => '3882838223',
      'rhel7'    => '1383823923'
    }
  end

  let(:facts) do
    {
      'operatingsystemrelease' => 'unknown',
      'virtual' => 'unknown'
    }
  end

  let(:function_args) do
    [reg_map, criteria, facts]
  end

  let(:criteria) do
    ['virtual', 'operatingsystemrelease']
  end

  it 'should return an empty string' do
    is_expected.to run.with_params(*function_args).and_return('')
  end

  it 'should raise error' do
    is_expected.to run.with_params("ten",6).and_raise_error(ArgumentError, /expects 3 arguments, got 2/)
  end

  describe 'vmware' do
    let(:facts) do
      {
        'operatingsystemrelease' => 'unknown',
        'virtual' => 'vmware'
      }
    end
    let(:return_value) do
      '3882838223'
    end
    it 'should return data' do
      is_expected.to run.with_params(*function_args).and_return(return_value)
    end
    describe 'rhel6' do
      let(:facts) do
        {
          'operatingsystemrelease' => 'rhel6',
          'virtual' => 'vmware'
        }
      end
      let(:return_value) do
        '3882838223,12393828293'
      end
      it 'should return data' do
        is_expected.to run.with_params(*function_args).and_return(return_value)
      end
    end
    describe 'rhel7' do
      let(:facts) do
        {
          'operatingsystemrelease' => 'rhel7',
          'virtual' => 'vmware'
        }
      end
      let(:return_value) do
        '3882838223,1383823923'
      end
      it 'should return data' do
        is_expected.to run.with_params(*function_args).and_return(return_value)
      end
    end
  end

  describe 'physical' do
    let(:facts) do
      {
        'operatingsystemrelease' => 'unknown',
        'virtual' => 'physical'
      }
    end
    let(:return_value) do
      '128283828'
    end
    it 'should return data' do
      is_expected.to run.with_params(*function_args).and_return(return_value)
    end
    describe 'rhel6' do
      let(:facts) do
        {
          'operatingsystemrelease' => 'rhel6',
          'virtual' => 'physical'
        }
      end
      let(:return_value) do
        '128283828,12393828293'
      end
      it 'should return data' do
        is_expected.to run.with_params(*function_args).and_return(return_value)
      end
    end

    describe 'rhel7' do
      let(:facts) do
        {
          'operatingsystemrelease' => 'rhel7',
          'virtual' => 'physical'
        }
      end
      let(:return_value) do
        '128283828,1383823923'
      end
      it 'should return data' do
        is_expected.to run.with_params(*function_args).and_return(return_value)
      end
    end
  end
end
