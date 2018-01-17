function plot = plot_clusters_2d (data, k, indices)
  % Simply takes data, k and ownership indices and plots the data points with
  % k colour-coded clusters 

  for i = 1:k
    colour = [rand; rand; rand];
    x = data(indices == i, 1);
    y = data(indices == i, 2);
    plot(x, y, '.', 'Color', colour, 'MarkerSize', 12);
    hold on
  end