### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ b465e181-9eef-4d27-aa19-5ad92dbfdb56
html"<button onclick='present()'>present</button>"

# ╔═╡ d5aa9c70-3c93-11ec-2921-0d063ab70e95
md"""
# Lecture 4
"""

# ╔═╡ 00800f4b-d5a7-41a9-bfe0-4981b1ea82af
html"""
        <h1 style="color:black;" id="Curve Fitting 2">Curve Fitting 2</h1>
        <div style="background-color:Lavender; margin-left: 20px; margin-right: 20px; padding-bottom: 8px; padding-left:
        8px; padding-right: 8px; padding-top: 8px; border-radius: 25px;">
        <p>We continue with Curve Fitting. This week introducing the general expression.</p>
        <p>Reading: Capra and Canale, introduction to part 5 and chapter 17.</p>
      </div>
      <br>
      <div style="background-color:Gold; margin-left: 20px; margin-right: 20px; padding-bottom: 8px; padding-left:
      8px; padding-right: 8px; padding-top: 8px; border-radius: 25px;">
      <p>Learning outcomes:</p>
      <li> Extend the work on Linear Regression to general linear combination of fitting functions.</li>
      <li> Combine C++, python and analytical solutions or other platforms.</li>
      <li> Check your code works correctly, via an external reference.</li>	
    </div>
    <br>
    <div style="background-color:Lavender; margin-left: 20px; margin-right: 20px; padding-bottom: 8px; padding-left:
    8px; padding-right: 8px; padding-top: 8px; border-radius: 25px;">

    <h3>Matt Watkins mwatkins@lincoln.ac.uk</h3>
  </div>
</section>"""

# ╔═╡ 6b138209-eddb-40f7-b1a8-16e77342fc8b
md"""
## General Linear Least Squares
``\newcommand{\vect}[1]{\boldsymbol{#1}}``
Simple linear, polynomial and multiple linear regression can be generalised to the following linear least-squares model

``
y_i = a_0 z_0 (x_i) + a_1 z_1 (x_i) + a_2 z_2 (x_i) + \cdots + a_{m-1} z_{m-1} (x_i) + e_i
``

we can use not only polynomials in ``x`` but any *predefined* functions of them.

We define our ``z_0(x), z_1( x), \ldots , z_{m-1}( x )``  **basis functions**. These predefined basis functions define the model. They only depend on the ``x`` coordinate. Examples could be polynomials, trigonometric, or Gaussian functions.

It is called **linear** least squares as the parameters ``a_0, a_1, \ldots, a_{m-1}`` appear linearly. The ``z``s can be highly non-linear in ``x``.

!!! warning "Example"
	For instance

	``
	y_i = a_0 \cdot 1 + a_1 \cos (\omega x_i) + a_2 \sin (\omega x_i)
	``

	is of this form with ``z_0 = 1, z_1 = \cos(\omega x_i)`` and ``z_2 = \sin(\omega x_i)``. Where ``x`` is a single independent variable and ``\omega`` is a predefined constant.

"""

# ╔═╡ a5b5ba48-d1bc-4bcf-af2b-c30c4b06fb37
md"""
## General Matrix Formulation

We can rewrite

```math
\begin{align}
y_i = & a_0 z_0 (x_i) + a_1 z_1 (x_i) + a_2 z_2 (x_i) + \cdots + a_{m-1} z_{m-1} (x_i) + e_i \\
= & \sum_{j=0}^{m-1} a_j z_{ij} + e_i
\end{align}
```

in matrix notation as

``
\vect{y} = \vect{Z} \vect{a} + \vect{e}
``

where bold lower case indicates a column vector, and bold uppercase indicates a matrix.
``\vect{Z}`` contains the calculated values of the ``m`` basis functions at the ``n`` measured values of the independent variables:

```math
\vect{Z} =
\left[
\begin{matrix}
z_0 (x_0) & z_1 (x_0) & \cdots & z_{m-1} (x_0) \\
z_0 (x_1) & z_1 (x_1) & \cdots & z_{m-1} (x_1) \\
\vdots & \vdots & \ddots & \vdots \\
z_0 (x_{n-1}) & z_1 (x_{n-1}) & \cdots & z_{m-1} (x_{n-1}) \\
\end{matrix}
\right]
=
\left[
\begin{matrix}
z_{00} & z_{01} & \cdots & z_{0 (m-1)} \\
z_{10} & z_{11} & \cdots & z_{1 (m-1)} \\
\vdots & \vdots & \ddots & \vdots \\
z_{(n-1) 0} & z_{(n-1) 1} & \cdots & z_{(n-1) (m-1)} \\
\end{matrix}
\right]
```

The column vector ``\vect{y}`` contains the ``n`` observed values of the dependent variable

``
\vect{y}^T = \left[y_0, y_1, y_2, y_3, \ldots, y_{n-1}  \right]
``

The column vector $\vect{a}$ contains the ``m`` unknown parameters of the model

``
\vect{a}^T = \left[a_0, a_1, a_2, \ldots, a_{m-1}  \right]
``

The column vector ``\vect{e}`` contains the ``n`` observed residuals (errors)

``
\vect{e}^T = \left[e_0, e_1, e_2, e_3, \ldots, e_{n-1} \right] 
``
"""

# ╔═╡ 91da805b-b30c-4bc7-8368-28e42e81f2e9
md"""
## Sum of squared errors as a vector norm

We can also express error in our model as a sum of the squares much like before:
```math
\begin{align*}
S_r & = \sum_{i=0}^{n-1}\left(y_i - \sum_{j=0}^{m-1} a_j z_{ij}  \right)^2 \\
& = \sum e_i^2 = \vect{e}^T \vect{e} = (\vect{y} - \vect{Z} \vect{a})^T (\vect{y} - \vect{Z} \vect{a})
\end{align*}
```
``S_r`` is minimised by taking partial derivatives wrt ``\vect{a}``, which yields

```math
\vect{Z}^T \vect{Z} \vect{a} = \vect{Z}^T \vect{y}
```
which is exactly equivalent to the set of simultaneous equations for ``a_i`` we found previously when fitting polynomials.

This set of equations is of the form ``\vect{A} \vect{x} = \vect{b}`` and can be solved using gauss elimination or similar method.
"""

# ╔═╡ 91ea73c9-4c2c-4356-a5ff-569d5f55a01b
html"""<div style="background-color:Lavender; margin-left: 20px; margin-right: 20px; padding-bottom: 8px; padding-left:
8px; padding-right: 8px; padding-top: 8px; border-radius: 25px;">
Try to redo the earlier fitting problems in this notation / method.</p>
</div>"""

# ╔═╡ d89e6352-1ac4-4938-8203-298d154fabda
md"""
!!! warn "Derivation of the gradient expression"
	
	```math
	\begin{align*}
	S_r & = \sum_{i=0}^{n-1}\left(y_i - \sum_{j=0}^{m-1} a_j z_{ij}  \right)^2 \\
	& = \sum e_i^2 = \vect{e}^T \vect{e} \\
	& = (\vect{y} - \vect{Z} \vect{a})^T (\vect{y} - \vect{Z} \vect{a}) \\
	& = \vect{y}^T \vect{y} - \vect{y}^T \vect{Za} - (\vect{Za})^T \vect{y} + (\vect{Za})^T\vect{Za}\\
	& = \vect{y}^T \vect{y} - 2 \vect{a}^T \vect{Z}^T\vect{y} + \vect{a}^T ( \vect{Z}^T \vect{Z}) \vect{a} 
	\end{align*}
	```
	
	taking the partial derivative with respect to $a_k$ can be done using components and leads to
	
	```math
	\frac{\partial (\vect{y}^T \vect{y})}{\partial a_k} = 0
	```
	
	as it doesn't depend on the coefficients. This is the same for each $a_k$ giving us
	
	```math
	\frac{\partial (\vect{y}^T \vect{y})}{\partial \vect{a}} = \vect{0}
	```
	
	The 2nd part contains sums each element dependent on a single $a_k$ 
	
	```math
	\begin{align*}
	\frac{\partial (2 \vect{a}^T \vect{Z}^T \vect{y})}{\partial a_k} & = \frac{\partial \sum_i \sum_j 2 a_i Z^T_{ij} y_j )}{\partial a_k} \\
	& = \sum_j 2 Z^T_{kj} y_j
	\end{align*} 
	```
	
	so the gradient of the 2nd part can be written
	
	```math
	\frac{\partial (2 \vect{a}^T \vect{Z}^T \vect{a})}{\partial \vect{a}} = 2\vect{Z}^T \vect{y}
	```
	the last term can be worked out similarly
	
	```math
	\begin{align*} 
	\frac{ \partial (\vect{a}^T\vect{Z}^T \vect{Z} \vect{a})} {\partial a_k} 
	& =  \frac{\partial \sum_i \sum_j a_i (Z^T Z)_{ij} a_j )}{\partial a_k} \\
	& = \sum_j (Z^T Z)_{kj} a_j + \sum_i a_i (Z^T Z)_{ik} \\
	& = 2 \sum_j (Z^T Z)_{kj} a_j
	\end{align*} 
	```
	
	with the last line following as $\vect{Z}^T\vect{Z}$ is symmetric we get the final term 
	
	```math
	\frac{\partial (\vect{a}^T \vect{Z}^T\vect{Za})}{\partial \vect{a}} = 2\vect{Z}^T \vect{Za}.
	```
	Combining the three parts and setting the grad of squared error equal to zero leads to the expression given:
	```math
	\vect{Z}^T \vect{Z} \vect{a} = \vect{Z}^T \vect{y}
	```
"""

# ╔═╡ 9e132065-66c2-4d36-952e-ded030fa56f9
md"""
## Example fitting

Suppose we have 11 measurements at 

```math
x^T = [-3. , -2.3, -1.6, -0.9, -0.2,  0.5,  1.2,  1.9,  2.6,  3.3,  4.0]
```
with measured values

```math
y^T = [
8.26383742,  6.44045188,  4.74903073,
4.5656476 ,  3.61011683, 3.32743918,  
2.9643915 ,  1.02239181,  1.09485138,  
1.84053372, 1.49110572]
```

![data](genRegData.png)

Let us fit it to a model of the form 

```math
y_i = a_0 \cdot 1 + a_1 e^{-x_i} + a_2 e^{-2x_i}
```
"""

# ╔═╡ c6592976-427c-46cd-9d29-4f450a5fb6b7
md"""
Our $\vect{Z}$ matrix has 3 columns for the basis functions $z_0 (x_i) = 1$, $z_1 (x_i) = e^{-x_i}$ and finally $z_2 = e^{-2x_i}$. It will have 11 rows corresponding to the 11 measurements.

```code
Z = 
[
[  1.00000000e+00,   2.00855369e+01,   4.03428793e+02],
[  1.00000000e+00,   9.97418245e+00,   9.94843156e+01],
[  1.00000000e+00,   4.95303242e+00,   2.45325302e+01],
[  1.00000000e+00,   2.45960311e+00,   6.04964746e+00],
[  1.00000000e+00,   1.22140276e+00,   1.49182470e+00],
[  1.00000000e+00,   6.06530660e-01,   3.67879441e-01],
[  1.00000000e+00,   3.01194212e-01,   9.07179533e-02],
[  1.00000000e+00,   1.49568619e-01,   2.23707719e-02],
[  1.00000000e+00,   7.42735782e-02,   5.51656442e-03],
[  1.00000000e+00,   3.68831674e-02,   1.36036804e-03],
[  1.00000000e+00,   1.83156389e-02,   3.35462628e-04]]
```

Then we set up the linear equation problem by forming $\vect{Z}^T \vect{Z}$ 

```code
ZTZ =
[
[  1.10000000e+01,   3.98805235e+01,   5.35475292e+02],
[  3.98805235e+01,   5.35475292e+02,   9.23382518e+03],
[  5.35475292e+02,   9.23382518e+03,   1.73292733e+05]]        
```

and ``\vect{Z}^T \vect{y}``

```code
ZTy = [   39.36979777,   272.62352738,  4125.63079852]
```
"""

# ╔═╡ 6d88c54e-3cff-4819-9bd3-2e0c570b5b22
md"""
The solution vector $\vect{a}$ of 
```math
\vect{Z}^T \vect{Z} \vect{a} = \vect{Z}^T \vect{y}
``` is 

```code
a = [ 2.01123234,  0.68962611,   -0.01915384]
```

This means that our final model for the data is

```math	
y = 2.01123234 + 0.68962611 e^{-x} - 0.01915384 e^{-2x}
```

![fitted data](fittedModel.png)

"""

# ╔═╡ Cell order:
# ╟─b465e181-9eef-4d27-aa19-5ad92dbfdb56
# ╟─d5aa9c70-3c93-11ec-2921-0d063ab70e95
# ╟─00800f4b-d5a7-41a9-bfe0-4981b1ea82af
# ╟─6b138209-eddb-40f7-b1a8-16e77342fc8b
# ╟─a5b5ba48-d1bc-4bcf-af2b-c30c4b06fb37
# ╟─91da805b-b30c-4bc7-8368-28e42e81f2e9
# ╟─91ea73c9-4c2c-4356-a5ff-569d5f55a01b
# ╟─d89e6352-1ac4-4938-8203-298d154fabda
# ╟─9e132065-66c2-4d36-952e-ded030fa56f9
# ╟─c6592976-427c-46cd-9d29-4f450a5fb6b7
# ╟─6d88c54e-3cff-4819-9bd3-2e0c570b5b22
