# SPRender
### Rendering 3D shapes in Matlab for shape processing publications.

Rendering is hard!

In the field of shape processing, it is often required to display function values, segmentation, or feature points over 3D shapes.
Alas, not all researchers have the necessary knowledge, artistic skills, and extra time to produce nice looking renders.
This package renders nice looking images and does not require any external dependencies or compiled mex files - so it is super easy to use.

Professional tools such as [Blender](https://www.blender.org/) or
[Maya](http://www.autodesk.com/products/maya/overview) are sometimes used for this task,
but they require a lot of manual work.
Text-based renderers such as [POV-Ray](http://www.povray.org/) require a lot of tedious coding.
Rendering shapes directly in Matlab can be easier, but it is hard to create a high quality render in Matlab.
*SPRender* solves this problem by providing a standard setup for lighting and rendering a matlab figure with 
carefully tuned parameters. 

### Capabilities

The heart of this package is a function called `MakeFigureNice()`. 
This function takes no arguments, and applies a lighting setup and some rendering parameters to the active figure.
This means you can *potentially* use it to improve your own figures created with `patch` or `trimesh` matlab functions.

However, the package is intended to be used as a one-stop solution for rendering a 3D shape,
and as such provides the following capabilities:

- Render a basic 3D shape with a single color (useful for e.g. shape retrieval papers).
- Render a real-valued function over a shape.
- Render a segmented shape. Segments can be visualized by highlighting their outline or coloring each segment in a different color. 
The colors are designed to be eye catching and distinct while not being too flashy.
- Render a real-valued function over a segmented shape, where segments are indicated by their outline.
- Render feature points over a shape. Feature points can be drawn on top of functions or segments.
- Render all of the above as triangular meshes or as point clouds.
- Comparing two segmented shapes side by side.

A few example renders are displayed below (click to view full resolution):

<img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/segments.png"          width="290px" alt="Segmented shape."                        
/><img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/segments_edges.png"  width="290px" alt="Segmented shape with segment outlines."
/><img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/function.png"        width="290px" alt="Real-valued function over a shape." />

<img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/function_segments.png"     width="290px" alt="Segment outlines over a real-valued function."                        
/><img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/pointcloud_function.png" width="290px" alt="Real-valued function over a point cloud."
/><img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/pointcloud_segments.png" width="290px" alt="Segmented point-cloud." />

<img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/features2.png"       width="290px" alt="Shape with feature points."                        
/><img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/compare_edges.png" width="290px" alt="Comparing two segmented shapes."
/><img src="https://raw.githubusercontent.com/hexygen/SPRender/master/examples/compare_pointclouds.png" width="290px" alt="Comparing two segmented point clouds." />


## Functions
*Note: I list the common function parameters in the next section. For detailed documentation see the code.*

`MakeFigureNice()`

This function takes no arguments and applies a lighting setup and some rendering parameters to the active figure.

`[ fig, S ] = RenderMeshFunction( shape, f, rotation, savename, fig )`

Renders a real-valued function over a triangular mesh.

`[ fig, S ] = RenderMeshSegments( shape, segs, show_edges, rotation, savename, fig )`

Renders a segmented triangular mesh.

`[ fig, S ] = RenderMeshFeaturePoints( shape, features, rotation, savename, fig )`

Renders a one-colored triangular mesh with highlighted feature points. For combining feature points with functions or segments, use `RenderShapeBase`.

`[ fig, S1, S2 ] = CompareSegmentedMeshes( shape1, segs1, shape2, segs2, show_edges, rotation, savename, fig )`
 
Renders two segmented triangular meshes side by side for comparison.

`[ fig, S ] = RenderPointCloudFunction( shape, f, rotation, savename, fig )`

Renders a real-valued function over a point cloud.

`[ fig, S ] = RenderPointCloudSegments( shape, segs, rotation, savename, fig  )`

Renders a segmented point cloud.

`[ fig, S1, S2 ] = CompareSegmentedPointClouds( shape1, segs1, shape2, segs2, rotation, savename, fig )`

Render two segmented point clouds side by side for comparison.

`[ fig, S ] = RenderShapeBase( shape, segs, f, features, is_pcd, show_segs, show_edges, show_marker_edge, rotation, savename, fig, face_color, marker_color )`

A base function that covers all of the functionality for rendering a single shape, which can be either a triangular mesh or a point cloud.
Use this function for any scenario not covered one of the functions above.


### Internal Functions

`[ cmap ] = get_colormap( nc )`

Returns a color map with `nc` segment colors.

`[ rot ] = get_rotation( key )`

Serves as a dictionary of preset rotation values. Returns a vector `[x, y, z]` of rotation values 
based on string keys such as 'tosca' or 'faust' which correspond to common datasets used in shape processing papers.

`[ S ] = ShapeStruct( vertices, triangles )`

Builds a shape structure from a list of vertices and a list of triangles (both `n` by `3`).
This shape structure is used for the rendering functions.

`[ S ] = rotate_mesh( S, rot )`

Rotates a mesh in 3D space.

## Parameters

`fig` - A handle to the resulting figure. Figures can be reused by providing the handle as an input.

`shape` - A shape, given as the name of an *.off* file or a shape structure. 
Shapes can be reused by feeding the output `S` into the next function.

`segs` - A segmentation, given as a vector with a segment ID for each vertex on the shape.
Can also be the name of a *.seg* file which contains that vector in text format.

`f` - A function to be displayed on the surface of the shape. The function values should be given as
a vector that holds one value for each vertex on the shape.

`features` - A vector that contains a list of features to highlight on the shape.
Can also be the name of a file which contains that vector in text format. 
Note that in that case the vertex index is `x+1` for each `x` in `features` (to comply with the zero-based feature list of SHREC dataset).

`is_pcd` - Indicates whether the shape is a point cloud. 0 by default, 1 for point clouds.

`show_segs` - Indicates whether to show the segments' colors on the surface of the shape. Default is 1.

`show_edges` - Indicates whether to show the segments' outlines on the shape. Default is 0.

`show_marker_edge` - Indicates whether to show a border for feature markers. Default is 0.

`rotation` - Either a vector `[x,y,z]` of rotation values or a string key such as `'tosca'` or `'faust'`
that indicates a preset rotation.

`savename` - Name of figure to save. Figures are saved in a high printing quality using matlab's `print` function.

`face_color` - If provided, indicates the base color of the shape, which is rendered when no function or segmentation are given.

`marker_color` - If provided, indicates the color of the marker when no function or segmentation are given.


## Under the Hood

The tricky part about rendering is creating a well balanced lighting setup.
The lighting setup in *SPRender* is made out of 8 directional lights, which come from each corner of the cube around the shape,
and have different intensities to avoid a flat look. 
This means that when you rotate the image in matlab, you will see that the back side of the shape is not as well lit as the front.
It is important to rotate the shape *before* the render (using the `rotation` parameter) to get the best lighting of the shape.
It also allows saving the image without user interaction, which is not possible when rotating the shape after the figure is displayed.

The lighting setup also involves a few tricks in maltab which are not well known, in particular adding a colorful ambient light
to avoid dark or murky areas on the render.

----
I hope you find this package useful. I am using it intensely for my own projects.

-Yanir
