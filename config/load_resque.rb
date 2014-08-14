require 'resque'


def init_resque
  Resque.redis = 'localhost:6379'
end
