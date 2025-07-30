# I/ Design timing summary
Show us the worst setup & hold path in the design
<img width="1057" height="206" alt="Image" src="https://github.com/user-attachments/assets/8eced37d-3db1-4920-8c0d-34be0a5d6b37" />
## a/ Worst setup slack
The worst setup slack in our design appear at the path from w_en to input of fifo_reg[3][3]/D
<img width="964" height="360" alt="Image" src="https://github.com/user-attachments/assets/1fb7aa85-4f94-4c6a-a55b-baf7be33a140" />
<img width="1506" height="565" alt="Image" src="https://github.com/user-attachments/assets/568fd0a2-12e2-4835-9bb1-4c87a4c80179" />
<img width="1205" height="447" alt="Image" src="https://github.com/user-attachments/assets/a6d0f203-18d1-40b5-b2c1-321e39e2390e" />
## b/ Worst hold slack
The worst hold slack in our design appear at the path from data_in[2] to fifo_reg[6][2]/D
<img width="1057" height="206" alt="Image" src="https://github.com/user-attachments/assets/8eced37d-3db1-4920-8c0d-34be0a5d6b37" />
<img width="1065" height="390" alt="Image" src="https://github.com/user-attachments/assets/b50a1bd8-231e-4dd7-bd63-9739c2982d37" />
<img width="1025" height="453" alt="Image" src="https://github.com/user-attachments/assets/44dd55a3-d692-40b3-84ef-4dacde03f16e" />
# II/ Input ports setup/hold slack
We randomly choose a report on the input ports "data_in[2]" and analyze it setup and hold path.
## a/ Setup slack
<img width="999" height="700" alt="Image" src="https://github.com/user-attachments/assets/9f4b10de-8e84-463d-b054-6ae38b37d567" />
<img width="1001" height="390" alt="Image" src="https://github.com/user-attachments/assets/43b0d516-96be-4053-8cf9-5216a8d90aed" /><br>
## b/ Hold slack
<img width="1258" height="659" alt="Image" src="https://github.com/user-attachments/assets/f9aae4ae-d2fc-4f49-bfa2-554ca00f5b1e" />
<img width="1050" height="394" alt="Image" src="https://github.com/user-attachments/assets/1f9b649d-e1fa-4228-8d6c-9aafa2a1129b" />

