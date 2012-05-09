# Rack Middleware
class ObjectAngel
  def initialize(app, options = {})
    @app = app
    @base_classes = Array(options[:classes] || 'Object').map(&:constantize)
  end

  def call(env)
    ini_state = current_object_counts_by_class
    response = @app.call(env)
    end_state = current_object_counts_by_class

    begin
      path = env['REQUEST_PATH']

      @base_classes.each do |klass|
        diff = end_state[klass] - ini_state[klass]
        action = diff >= 0 ? 'ALLOCATE' : 'DEALLOCATE'

        log "[#{path}][#{action}] #{highlight(diff, YELLOW)} " <<
          "#{highlight(klass, GREEN)} objects"
      end
    rescue => e
      error(e.message)
    end
 
    response
  end

protected
  def current_object_counts_by_class
    counts_by_class = @base_classes.map { |klass|
      [klass, ObjectSpace.each_object(klass).count]
    }

    Hash[*counts_by_class.flatten]
  end

  def log(text)
    Rails.logger.debug text
  end

  def error(text)
    log highlight(text, RED)
  end

  YELLOW = '1;33m'; RED = '1;31m'; GREEN = '1;32m'
  def highlight(text, color)
    "\033[#{color}#{text.to_s}\033[0m"
  end
end