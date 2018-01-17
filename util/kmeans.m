function results = kmeans (data, k)
  % This code is based on an implementation of the kmeans algorithm originally 
  % written by Marcus Gallagher, of the University of Queensland.
  % It has been modified by Millie Macdonald for use in this project.
  
  % INPUT:
  %   data = an n x m (rows x cols or points x dimensions) matrix of numbers
  %   k = the number of centroids/clusters to find. 
  %       k > 1 && k < n
  
  % OUTPUT:
  %   data = returns data with the data points in random order, as used below
  %   startCentroids = the initial position of the centroids
  %   centroidHist = historical positions of the centroid
  %   iterations = the number of iterations before kmeans found a solution
  %   endHeurError = the final error value
  %   indices = an n x 1 array with indices to represent which cluster each data
  %      point belongs to in the final clustering
  %   centers = the final coordinates of the k centroids
  %   endCentroids = the final coords for the centroids
 

  %VARIABLES
  numPts = size(data, 1); % number of points (aka rows)
  numDim = size(data, 2); % number of dimensions (aka columns)
  
  % Return the basic variables
  results.k = k;
  results.numPts = numPts;
  results.numDim = numDim;
  
  currCentroids = zeros(k, size(data, 2)); % matrix for current centroid coords
  lastCentroids = zeros(k, size(data, 2)); % matrix for last centroid coords
  % TODO: make these cell arrays or something, so the centroids are seperate
  
  iterations = 0; % tracks the number of iterations so far
  
  % CHECKS
  % We must have at least as many data points as cluster centres, and k must be > 1
  if (k > numPts)
      disp('Error: k > num points');
      return
  end
  
  if (k <= 1)
      disp('Error: k <= 1');
      return
  end
  
  % KMEANS ALGORITHM  

  % Randomise the order of the data points and select the first k data points as 
  % the initial coords for the centroids
  data = data(randperm(numPts), :);
  
  currCentroids(1:k, :) = data(1:k, :);
  centroidHist(:, :, 1) = currCentroids(:, :); % cell array for historical centroid coords
  % TODO: make that a cell array of cell arrays, or something...
  
  % Return the new data matrix and the initial position of the centroids
  results.data = data; 
  results.startCentroids = currCentroids;

  exitcond = 0;
  runflag = 0;
  preverror = 0;

  % Main iterative k-means loop
  while ~exitcond
      % Pairwise distances of all data points
      D = pdist2(currCentroids, data);
      % D = reshape(D,(numpts-1),(size(D,2)/(numpts-1)))    % ???

      % Find which centroid each data point is closest to 
      % Note: this breaks if k = 1, hence the check above.
      [c, indices] = min(D);
      
      % Calculate heuristic error value for the current clustering
      heurError = 0;
      for i=1:k
          heurError = heurError + sum(pdist2(currCentroids(i, :), data(find(indices == i), :)).^2);
      end
      
      % Save the current centroid coords as lastCentroids for the next iteration
      lastCentroids = currCentroids;
      
      % Update each centroid to be at the mean of their cluster
      for i=1:k
          ownedPts = data(find(indices == i), :);
          if (size(ownedPts, 1) == 1)
              % If a centroid only owns one data point, just use that data point
              currCentroids(i,:) = ownedPts;
          else
              % Else use the mean of their owned data points
              currCentroids(i,:) = mean(ownedPts);
          end
      end
      
      % Add the new centroids to the historical cell array
      centroidHist(:, :, (iterations + 2)) = currCentroids(:, :);
      
      % Check for NaNs, which indicates a cluster centre that owns no points
      if (any(any(isnan(currCentroids))))
          disp('Error: a centroid owns no data points');
          exitcond=1;
      end
          
      %Terminate loop if centroids did not change
      if (all(all(currCentroids == lastCentroids)))
          disp('Success!');
          exitcond = 1;
      end
      
      iterations = iterations + 1;
  end
  
  % Return the final values
  results.iterations = iterations;
  results.endHeurError = heurError;
  results.centroidHist = centroidHist;
  results.indices = indices;
  results.endCentroids = currCentroids;