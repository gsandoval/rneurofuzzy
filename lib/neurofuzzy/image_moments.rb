module Neurofuzzy
  class ImageMoments
    def central_moment(p, q, img)
      m, n = [img.size, img[0].size]
      m00 = img.map {|x| x.reduce :+}.reduce :+
      m10 = 0
      m01 = 0
      for x in (0..m-1)
        for y in (0..n-1)
          m10 += x * img[x][y]
          m01 += y * img[x][y]
        end
      end
      xx = m10 / m00
      yy = m01 / m00

      mu_00 = m00
      mu_pq = 0

      for i in (0..m-1)
        x = i - xx
        for j in (0..n-1)
          y = j - yy
          mu_pq += x**p * y**q * img[i][j]
        end
      end

      gamma = 0.5 * (p + q) + 1
      mu_pq / m00**gamma
    end

    def hu_invariant_moments(img)
      n20 = central_moment(2, 0, img)
      n02 = central_moment(0, 2, img)
      m1 = n20 + n02

      n20 = central_moment(2, 0, img)
      n02 = central_moment(0, 2, img)
      n11 = central_moment(1, 1, img)
      m2 = (n20 - n02)**2 + 4 * n11**2

      n30 = central_moment(3, 0, img)
      n12 = central_moment(1, 2, img)
      n21 = central_moment(2, 1, img)
      n03 = central_moment(0, 3, img)
      m3 = (n30 - 3 * n12)**2 + (3 * n21 - n03)**2

      n30 = central_moment(3, 0, img)
      n12 = central_moment(1, 2, img)
      n21 = central_moment(2, 1, img)
      n03 = central_moment(0, 3, img)
      m4 = (n30 + n12)**2 + (n21 + n03)**2

      n30 = central_moment(3, 0, img)
      n12 = central_moment(1, 2, img)
      n21 = central_moment(2, 1, img)
      n03 = central_moment(0, 3, img)
      m5 = (n30 - 3 * n21) * (n30 + n12) * ((n30 + n12)**2 - 3 * (n21 + n03)**2) + (3 * n21 - n03) * (n21 + n03) * (3 * (n30 + n12)**2 - (n21 + n03)**2)

      n20 = central_moment(2, 0, img)
      n02 = central_moment(0, 2, img)
      n30 = central_moment(3, 0, img)
      n12 = central_moment(1, 2, img)
      n21 = central_moment(2, 1, img)
      n03 = central_moment(0, 3, img)
      n11 = central_moment(1, 1, img)
      m6 = (n20 - n02) * ((n30 + n12)**2 - (n21 + n03)**2) + 4 * n11 * (n30 + n12) * (n21 + n03)

      n30 = central_moment(3, 0, img)
      n12 = central_moment(1, 2, img)
      n21 = central_moment(2, 1, img)
      n03 = central_moment(0, 3, img)
      m7 = (3 * n21 - n03) * (n30 + n12) * ((n30 + n12)**2 - 3 * (n21 + n03)**2) - (n30 + 3 * n12) * (n21 + n03) * (3 * (n30 + n12)**2 - (n21 + n03)**2)

      [m1, m2, m3, m4, m5, m6, m7]
    end
  end
end
