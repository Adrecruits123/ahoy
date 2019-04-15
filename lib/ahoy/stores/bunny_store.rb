module Ahoy
  module Stores
    class BunnyStore < LogStore
      def log_visit(data)
        post(visits_queue, data)
      end

      def log_event(data)
        post(events_queue, data)
      end

      def channel
        @channel ||= begin
          conn = Bunny.new
          conn.start
          conn.create_channel
        end
      end

      def post(queue, message)
        channel.queue(queue, durable: true).publish(message.to_json)
      end

      def visits_queue
        "adr_visits"
      end

      def events_queue
        "adr_events"
      end
    end
  end
end
