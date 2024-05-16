import random

pixel_range = 256
random.seed(42)
sample_image = [[0 for _ in range(1024)]for _ in range(1024)]
grid_avgs = [[0 for _ in range(1024)]for _ in range(1024)]
size_N = 256


def get_input_pixels(infile):
    with open(infile) as input:
        for i in range(0, size_N):
            for j in range(0, size_N):
                pxl = int(input.readline())
                sample_image[i][j] = pxl

def calc_avg(i,j):
   row = i
   pxl = j
   grid00 = sample_image[i-1][j-1] if (i>0 and j>0) else 0
   grid01 = sample_image[i-1][j] if i>0 else 0
   grid02 = sample_image[i-1][j+1] if i>0 and j<size_N-1 else 0
   grid10 = sample_image[i][j-1] if j>0 else 0
   grid11 = sample_image[i][j]
   grid12 = sample_image[i][j+1] if j<size_N-1 else 0
   grid20 = sample_image[i+1][j-1] if (i<size_N-1 and j>0) else 0
   grid21 = sample_image[i+1][j] if i<size_N-1 else 0
   grid22 = sample_image[i+1][j+1] if (i<size_N-1 and j<size_N-1) else 0

   if (row%2==0 and pxl%2==0): #case ii
       R = (grid01+grid21)/2
       G = grid11
       B = (grid10+grid12)/2
   elif (row%2==0 and pxl%2==1): #case iv
       R = (grid00+grid02+grid20+grid22)/4
       G = (grid01+grid10+grid12+grid21)/4
       B = grid11
   elif (row%2==1 and pxl%2==0): #case iii
       R = grid11
       G = (grid01+grid10+grid12+grid21)/4
       B = (grid00+grid02+grid20+grid22)/4
   elif (row%2==1 and pxl%2==1): #case i
       R = (grid10+grid12)/2
       G = grid11
       B = (grid01+grid21)/2
   return (str(int(R)),str(int(G)),str(int(B)))

def calc_grid_averages(size_N):
    with open("averages_check.txt", "w") as wfile:
        for i in range (0,size_N):
            for j in range (0,size_N):
                avgR, avgG, avgB = calc_avg(i,j)
                wfile.write("("+avgR+","+avgG+","+avgB+")"+" ")
                if (j == size_N-1):
                    wfile.write("\n")
                    
                    

if __name__=="__main__":
    print("Enter image size N: ")
    size_N=int(input())
    get_input_pixels("bayer16x16_2024.txt")
    calc_grid_averages(size_N=size_N)
