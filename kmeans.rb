module Neurofuzzy
  class KMeans
    def initialize(cluster_count)
      @cluster_count = cluster_count
    end

    def clusterify(data)
      data_size = data[0].size
      ndata = normalize data, data_size
      ncentroids = random_centroids data_size
      centroids = Array.new(ncentroids.size, Array.new(data_size, 0))
      clustered = {}
      while centroids != ncentroids
        centroids = ncentroids
        clusters = Array.new(@cluster_count) {|i| []}
        clustered.clear
        ndata.each do |d|
          dists = centroids.map {|c| [d, c].transpose.map {|a, b| (a - b)**2}}.map {|dd| dd.reduce :+}
          cluster = dists.zip((0..@cluster_count-1).to_a).min {|a, b| a[0] <=> b[0]}[1]
          clusters[cluster].push d
          clustered[d] = cluster
        end
        ncentroids = Array.new(ncentroids.size, Array.new(data_size, 0))
        @cluster_count.times do |i|
          ncentroids[i] = clusters[i].transpose.map {|a| a.reduce :+}.map {|e| e / clusters[i].size} if clusters[i].size > 0
        end
      end
      ndata.map {|d| clustered[d]}
    end

    def random_centroids(data_size)
      (1..@cluster_count).map {|k| (1..data_size).map {|x| rand}}
    end

    def normalize(data, data_size)
      mins = Array.new(data_size, 1 << 32)
      maxs = Array.new(data_size, 0)
      data.each do |d|
        for i in (0..data_size-1)
          mins[i] = [mins[i], d[i]].min
          maxs[i] = [d[i], maxs[i]].max
        end
      end
      data.map {|d| d.zip(maxs, mins).map {|v, max, min| (v - min) * 1.0 / (max - min)}}
    end
  end
end