# Appendix
Description of the mathematical steps necessary for computing E and H inside a multilayer stack


## Common Assumptions

 - We consider a forward propagating plane wave in the form $\vec A = \vec A_m \cdot exp(-i \vec k \vec r + i \omega t)$.
   In such a way that  
$$\partial_t \vec A = i \omega \vec A$$, and  
$$\partial_{j} \vec A = - i k_{j} \vec A$$,  
where $j=x,y,z$.
 - We consider isotropic media with $\mu = \mu_0$.
 - The optical axis is $z$.
 - We consider waves with impinging at angle theta with $k_x = 0$.
   Therefore we can write $k_y=k \sin \theta$ and $k_z=k \cos \theta$.
 - Inside a medium with refractive index $n$ we write $k = n \cdot k_0$.

For reference, consider that the curl of a vector takes the form:  
$$ \nabla  \wedge \vec A = \hat x (partial_y A_z - partial_z A_y) + \hat y (partial_z A_x - partial_x A_z)  + \hat z (partial_x A_y - partial_y A_x)  $$,  
where $\hat j$ is a versor in the direction $j$

## s-polarization (E is parallel to the multilayer) 

Maxwell's curl equation for E takes the form:

$$ \nabla \wedge \vec E = - i \omega \mu_0 \vec H $$ 

Since $E_y = E_z=0$, for a forward propagating wave we can write:  
$$ \nabla \times \vec E = \hat y \cdot \partial_z E_x - \hat z \partial_y E_x  = - i \omega \mu_0 \vec H $$

$$ H_y = \frac{1}{-i \omega \mu_0}\cdot (-i k_z) E_x = \frac{n k_0 \cos \theta}{\omega \mu_0} E_x $$,  
$$ H_y = \frac{n}{Z_0}  \cos \theta E_x $$.

$$ H_z = -\frac{1}{- i \omega \mu_0}\cdot (-i k_y) E_x = \frac{n k_0 \sin \theta}{\omega \mu_0} E_x $$,  
$$ H_z = \frac{n}{Z_0}  \sin \theta E_x $$.




## s-polarization (H is parallel to the multilayer) 

$$ \nabla \times \vec H = + i \omega \epsilon E $$.
