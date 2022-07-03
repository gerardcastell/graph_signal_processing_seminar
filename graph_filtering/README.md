US Weather Station
==================

Abstract
--------

In this practice we have constructed several graph filters to evaluate
the temperature from 200 stations during 365 days in the U.S in the
2002. Such stations are connected geographically with the 8 closest
stations. In addition, it is also provided the position of the stations
so we are able to build a graph and we know the connections, i.e. edges,
of each one. So the target of this session is to apply a low and a
high-pass filter for different day of each season and obtain the graph
with the applied filtered signals.

Reading and visualization of the data
-------------------------------------

To perform this experiment we have retrieved three matrices from the
dataset.

-   **Y**. It is the vector which contains the temperature in Fahrenheit
    degrees of the 200 stations along 365 days. So it is a matrix of
    200x365. In order to ease the understanding of the plots it has been
    transformed to Celsius degrees.

-   **A**. It is the adjacency matrix of the graph that relates the
    stations and how they are connected. Hence, its dimensions are
    200x200.

-   **pos**. It defines the position of the stations in geographical
    coordinates, so it is 200x2.

Generation of an undirected graph
---------------------------------

Thanks to the data explained in the previous section we are able to
build a graph. The resulting image is the following.

![Plot of the temperature per station during a whole
year.](images/1.png){#fig:temperaturePlot width="13cm"}

With that information we were able to build a directed graph such as
this:

![Plot of the directed graph of the
stations.](images/2.png){#fig:directedGraph width="13cm"}

After that, we have looked for the Hawaii stations and removed the three
entries related to that coordinates. The resulting graph is the
following:

![Plot of the directed graph removing Hawaii
entries.](images/3.png){#fig:excludedHawaiiGraph width="10cm"}

As you can see if you compare the graph
[2](#fig:directedGraph){reference-type="ref"
reference="fig:directedGraph"} with the previous one
[3](#fig:excludedHawaiiGraph){reference-type="ref"
reference="fig:excludedHawaiiGraph"}, we can see how the nodes at the
south-west corner has been erased. So they are not going to be
considered in the experiment. Finally, we have converted the graph to
undirected in order to simplify the calculations.

![Plot of the directed graph removing Hawaii
entries.](images/4.png){#fig:undirectedGraph width="10cm"}

Low pass filter
---------------

We have developed a filter function with the aim of given a Graph, a
filter function, which will depend of it purpose, and an input signal.
As output it returns the resulting filtered signal. $filter(G,x, h)$:
[\[code:CNScoring\]]{#code:CNScoring label="code:CNScoring"}

    function y = filter(G,x, h)
        x_hat = G.U' * x;
        y_hat_l = h.*x_hat;
        y = G.U*y_hat_l;
    end

So we have selected a random day and we have computed the Graph Fourier
Basis with the function $gsp\_compute\_fourier\_basis(G_u)$, where $G_u$
is the undirected graph without Hawaii stations. The low pass filter has
been calculated as this: $\tilde{h}_l= 1/(1+G_u.e)$ The resulting plot
that compares the input signal in the graph with the low pass filter is
this:

![Plot of the low pass filter graph compared with the original input
signal.](images/5.png){#fig:lowpassfilterrandom width="13cm"}

As we may observe in the plot, the temperatures across the graph does
not have heavy variations, keeping the lowest temperature nodes. If we
focus on the right-side nodes we can see how the temperature propagates
to the left nodes without changing the temperature that sudden as the
original signal.

High pass filter
----------------

For this purpose we have used the previous function $filter(G,x, h)$ but
this time with the High pass filter definition
$\tilde{h}_h= 1/(1-(G_u.e-\lambda_{max}))$. Applying such a filter to
the same input signal than before we obtain this representation.

![Plot of the high pass filter graph compared with the original input
signal.](images/6.png){#fig:lowpassfilterrandom width="10cm"}

On the other hand, the whole graph contains red, orange and yellow
nodes, and we can see that the interval of values that are represented
in the graph is from -4 to 2 degrees Celsius. This means that the
high-pass filter will remove the temperature information from the data
and maintain the noise from the data. What is represented then, is
mostly the noise.

High and low pass filter per season 
-----------------------------------

For the final part, we have plot a random day for each season in order
to see how the filters works for each stage of the year.

![Plot of the high pass filter graph compared with the original input
signal.](images/7.png){#fig:lowpassfilterrandom width="10cm"}

![Plot of the high pass filter graph compared with the original input
signal.](images/8.png){#fig:lowpassfilterrandom width="10cm"}

![Plot of the high pass filter graph compared with the original input
signal.](images/9.png){#fig:lowpassfilterrandom width="10cm"}

![Plot of the high pass filter graph compared with the original input
signal.](images/10.png){#fig:lowpassfilterrandom width="10cm"}

In the previous images we can see that the temperatures in have a great
variation in the original data, as it is in the United States of America
and the country is huge. Therefore, it is normal that the temperature in
the different places is extremely different. In this sense, using a low
pass filter will help us keep the most relevant data and we well see a
decrease in the range values of the legend, thus helping us getting the
most relevant information. The graph will turn out to be more smooth,
due to the effect of the low-pass filter.

Applying the high-pass filter will remove the temperature information in
the lowest frequencies and mostly noise will remain.
