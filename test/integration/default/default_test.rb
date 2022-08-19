# Chef InSpec test for recipe checkmks::default

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

unless os.windows?
  describe user('root'), :skip do
    it { should exist }
  end
end

describe port(80), :skip do
  it { should_not be_listening }
end

describe port(443), :skip do
  it { should_not be_listening }
end

describe port(16556), :skip do
  it { should_not be_listening }
end
