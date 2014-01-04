module PiPiper
  # Represents a PWM pin on the Raspberry Pi.  
  # Requires pi-blaster to work - https://github.com/sarfata/pi-blaster/
  class Pwm

    # These are the GPIO pins that pi-blaster supports for PWM
    VALID_PINS = [4, 17, 18, 21, 22, 23, 24, 25]

    attr_reader :pin

    #Initializes a new PWM pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    #
    def initialize(options)
      @pin       = options[:pin]

      raise "Couldn't find #{pwm_file}. Is pi-blaster installed and running?" unless 
      raise "Invalid pin. Valid options are "+VALID_PINS.join(", ") unless VALID_PINS.include? @pin

    end

    # Set the PWM level for this PWM pin
    #
    # @param [Float] value The PWM level to set. Valid values range from 0.0 (completely off) to 1.0 (permanently on).  Required.
    def value(value)
      raise "Value must be between 0 and 1" unless ((0 <= value) && (value <= 1))
      File.open(pwm_file, 'w') {|f| f.puts("#{@pin}=#{value}") }
    end

    # Release the pin to allow it to be reused for general GPIO
    def release
      File.open(pwm_file, 'w') {|f| f.puts("release #{@pin}") }
    end

    private
    def pwm_file
      "/dev/pi-blaster"
    end

  end
end
