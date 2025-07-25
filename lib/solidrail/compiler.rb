# frozen_string_literal: true

module SolidRail
  # Main compiler module that orchestrates the transpilation process
  class Compiler
    def initialize(options = {})
      @options = options
      @errors = []
      @warnings = []
    end

    def compile(source_code, output_file = nil)
      # Step 1: Validate Ruby code
      ruby_errors = Validator.validate_ruby_code(source_code)
      raise CompilationError, "Ruby validation failed:\n#{ruby_errors.join("\n")}" if ruby_errors.any?

      # Step 2: Parse Ruby code to AST
      ast = Parser.parse(source_code)

      # Step 3: Generate Solidity code
      solidity_code = Generator.generate_solidity(ast)

      # Step 4: Optimize the generated code
      optimized_code = Optimizer.optimize(solidity_code)

      # Step 5: Validate generated Solidity code
      solidity_errors = Validator.validate_solidity_code(optimized_code)
      @warnings += solidity_errors if solidity_errors.any?

      # Step 6: Write output if file specified
      File.write(output_file, optimized_code) if output_file

      {
        code: optimized_code,
        errors: @errors,
        warnings: @warnings,
        ast: ast
      }
    end

    def compile_file(input_file, output_file = nil)
      source_code = File.read(input_file)
      output_file ||= input_file.sub(/\.rb$/, '.sol')

      compile(source_code, output_file)
    end

    private

    def add_error(message)
      @errors << message
    end

    def add_warning(message)
      @warnings << message
    end
  end
end
