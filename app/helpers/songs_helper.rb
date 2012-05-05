module SongsHelper
  def format_time seconds
    minutes, seconds = seconds.divmod 60
    hours, minutes = minutes.divmod 60

    pad = ->(x) {x.to_s.rjust 2, '0'}

    if hours > 0
      "#{hours}:#{pad[minutes]}:#{pad[seconds]}"
    else
      "#{minutes}:#{pad[seconds]}"
    end
  end
end
