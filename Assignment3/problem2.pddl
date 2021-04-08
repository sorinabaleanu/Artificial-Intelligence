(define (problem prob)
 (:domain restaurant)
 (:objects 

    left right - hand
    chopper1  - chopper
    mixingbowl1  - mixingbowl
    pot1 - pot
    plate1 plate2 - plate
    tomato1 - tomato
    onion1 onion2 - onion
    garlic1 garlic2 - garlic
    cucumber1 - cucumber
    pasta1 - pasta
    rice1 - rice
    salad1 salad2 - salad
    riceWithVegetables1 - riceWithVegetables
    pastaWithVegetables1 - pastaWithVegetables
   
)
 (:init 
  (= (total-cost) 0)
  (ontable pot1)
  (ontable chopper1)
  (ontable mixingbowl1)
  (ontable plate1)
  (ontable plate2)
  (clean plate1)
  (clean plate2)
  (handempty left)
  (handempty right)
  (inFridge tomato1)
  (inFridge onion1)
  (inFridge onion2)
  (inFridge garlic1)
  (inFridge garlic2)
  (inFridge cucumber1)
  (inFridge rice1)
  (inFridge pasta1)
  (inFridge meat1)

)
 (:goal
  (and
 
 
   (readyToServe pastaWithVegetables1)
   (readyToServe riceWithVegetables1)
   (readyToServe salad1)
   (readyToServe salad2)
   
                              
     
))
(:metric minimize (total-cost)))