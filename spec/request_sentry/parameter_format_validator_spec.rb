require File.join(File.dirname(__FILE__), '../spec_helper')

module RequestSentry
  describe ParameterFormatValidator, "unknown parameter type" do
    it "should raise an error upon validation" do
      validator = ParameterFormatValidator.new(:raise_an_error_bubba)
      lambda { validator.valid?(:chicken) }.should raise_error
    end
  end

  describe ParameterFormatValidator, "empty values" do
    it "empty string should be valid" do
      validator = ParameterFormatValidator.new(:number)
      validator.valid?('').should be_true
    end

    it "nil should be valid" do
      validator = ParameterFormatValidator.new(:number)
      validator.valid?(nil).should be_true
    end
  end

  describe ParameterFormatValidator, "given a Regexp" do
    before(:each) do
      @validator = ParameterFormatValidator.new /\d+/
    end

    it "should be valid for a matching string" do
      @validator.valid?('123').should be_true
    end

    it "should be invalid for a non-matching string" do
      @validator.valid?('abc').should be_false
    end
  end

  describe ParameterFormatValidator, ":number" do
    before(:each) do
      @validator = ParameterFormatValidator.new :number
    end

    it "should accept 123" do
      @validator.valid?('123').should be_true
    end

    it "should accept 123.4" do
      @validator.valid?('123.4').should be_true
    end

    it "should accept +123" do
      @validator.valid?('+123').should be_true
    end

    it "should accept -123" do
      @validator.valid?('-123').should be_true
    end

    it "should not accept abc" do
      @validator.valid?('abc').should be_false
    end

    it "should not accept Jan 1, 2003" do
      @validator.valid?('Jan 1, 2003').should be_false
    end
  end

  describe ParameterFormatValidator, ":unsigned_number" do
    before(:each) do
      @validator = ParameterFormatValidator.new :unsigned_number
    end

    it "should accept 123" do
      @validator.valid?('123').should be_true
    end

    it "should accept 123.4" do
      @validator.valid?('123.4').should be_true
    end

    it "should accept +123" do
      @validator.valid?('+123').should be_true
    end

    it "should not accept -123" do
      @validator.valid?('-123').should be_false
    end

    it "should not accept abc" do
      @validator.valid?('abc').should be_false
    end

    it "should not accept Jan 1, 2003" do
      @validator.valid?('Jan 1, 2003').should be_false
    end
    
    it "should not accept {}" do
      @validator.valid?({}).should be_false
    end
  end

  describe ParameterFormatValidator, ":integer" do
    before(:each) do
      @validator = ParameterFormatValidator.new :integer
    end

    it "should accept 123" do
      @validator.valid?('123').should be_true
    end

    it "should not accept 123.4" do
      @validator.valid?('123.4').should be_false
    end

    it "should accept +123" do
      @validator.valid?('+123').should be_true
    end

    it "should accept -123" do
      @validator.valid?('-123').should be_true
    end

    it "should not accept abc" do
      @validator.valid?('abc').should be_false
    end

    it "should not accept Jan 1, 2003" do
      @validator.valid?('Jan 1, 2003').should be_false
    end
  end

  describe ParameterFormatValidator, ":unsigned_integer" do
    before(:each) do
      @validator = ParameterFormatValidator.new :unsigned_integer
    end

    it "should accept 123" do
      @validator.valid?('123').should be_true
    end

    it "should not accept 123.4" do
      @validator.valid?('123.4').should be_false
    end

    it "should accept +123" do
      @validator.valid?('+123').should be_true
    end

    it "should not accept -123" do
      @validator.valid?('-123').should be_false
    end

    it "should not accept abc" do
      @validator.valid?('abc').should be_false
    end

    it "should not accept Jan 1, 2003" do
      @validator.valid?('Jan 1, 2003').should be_false
    end
  end

  describe ParameterFormatValidator, ":boolean" do
    before(:each) do
      @validator = ParameterFormatValidator.new :boolean
    end

    it "should accept 1" do
      @validator.valid?('1').should be_true
    end

    it "should accept 0" do
      @validator.valid?('0').should be_true
    end

    it "should accept true" do
      @validator.valid?('true').should be_true
    end

    it "should accept false" do
      @validator.valid?('false').should be_true
    end

    it "should accept t" do
      @validator.valid?('t').should be_true
    end

    it "should accept f" do
      @validator.valid?('f').should be_true
    end

    it "should not accept falsey" do
      @validator.valid?('falsey').should be_false
    end
  end

  describe ParameterFormatValidator, ":date" do
    before(:each) do
      @validator = ParameterFormatValidator.new :date
    end

    it "should accept July 24, 1985" do
      @validator.valid?('July 24, 1985').should be_true
    end

    it "should accept 2009-09-15" do
      @validator.valid?('2009-09-15').should be_true
    end

    it "should not accept 1" do
      @validator.valid?('1').should be_false
    end
  end

  describe ParameterFormatValidator, "class types" do
    describe ":string" do
      before(:each) do
        @validator = ParameterFormatValidator.new(:string)
      end
      
      it "should fail when given a hash" do
        @validator.valid?({}).should be_false
      end

      it "should fail when given an array" do
        @validator.valid?([]).should be_false
      end
      
      it "should pass when given a string" do
        @validator.valid?('').should be_true
      end
    end

    describe ":hash" do
      before(:each) do
        @validator = ParameterFormatValidator.new(:hash)
      end
      
      it "should fail when given a string" do
        @validator.valid?('').should be_false
      end

      it "should fail when given an array" do
        @validator.valid?([]).should be_false
      end
      
      it "should pass when given a hash" do
        @validator.valid?({}).should be_true
      end
    end

    describe ":array" do
      before(:each) do
        @validator = ParameterFormatValidator.new(:array)
      end
      
      it "should fail when given a hash" do
        @validator.valid?({}).should be_false
      end

      it "should fail when given an string" do
        @validator.valid?('').should be_false
      end
      
      it "should pass when given an array" do
        @validator.valid?([]).should be_true
      end
    end
  end
end
