module Less2Sass
  module Less
    module Tree
      # Represents the expression in the Less AST.
      #
      # Sass does not have an Expression node. It is usually
      # represented as the `expr` member of the {::Sass::Tree::VariableNode},
      # that represents a variable definition.
      #
      # The Sass equivalent is either {::Sass::Script::Value::Base}
      # wrapped in {::Sass::Script::Tree::Literal} or {::Sass::Tree::Node}.
      class ExpressionNode < Node
        attr_accessor :value

        # @return [::Sass::Script::Tree::Literal, ::Sass::Script::Tree::ListLiteral, ::Sass::Tree::Node]
        # @see Node#to_sass
        def to_sass
          if @value.is_a?(Array)
            # TODO: document solution of: method to_sass is invoked on "to right":String, deal with it
            if is_multiword_keyword?
              multiword_keyword_argument
            elsif should_be_literal?
              @value.inject([]) { |value, elem| value << elem.to_s }.join(' ')
            else
              elements = @value.inject([]) do |value, elem|
                node = elem.to_sass
                node = node(::Sass::Script::Tree::Literal.new(node), line) if node.is_a?(::Sass::Script::Value::Base)
                value << node
              end
              node(::Sass::Script::Tree::ListLiteral.new(elements, :space), line)
            end
          else
            value = @value.to_sass
            return value unless value.is_a?(::Sass::Script::Value::Base)
            node(::Sass::Script::Tree::Literal.new(value), line)
          end
        end

        private

        LITERAL_PROPERTIES = %w(font transition).freeze

        # @todo: should be checked once more
        def is_multiword_keyword?
          @value.select { |elem| !elem.is_a?(KeywordNode) }.empty?
        end

        # Checks, whether the expression contains a {VariableNode}.
        # Some properties in Less store their values as string literals
        # instead of list literals.
        #
        # @return [Boolean] true if the expression should be converted
        #                   to {::Sass::Script::Tree::Literal}
        def should_be_literal?
          grandparent = @parent.parent
          return false unless grandparent.is_a?(RuleNode)
          LITERAL_PROPERTIES.include?(grandparent.name.value) && !contains_variables?
        end

        # Creates a {::Sass::Script::Tree::ListLiteral} out of
        # multiple keywords - usually referencing a complex CSS keyword.
        #
        # Example (`to right` is an example of multiword keyword):
        #   `list-style-image: linear-gradient(to right, rgba(255,0,0,0), rgba(255,0,0,1));`
        #
        def multiword_keyword_argument
          keywords = @value.inject([]) { |value, elem| value << elem.to_sass }
          node(::Sass::Script::Tree::ListLiteral.new(keywords, :space), line)
        end
      end
    end
  end
end