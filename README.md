### SELF HOSTED PREFECT / BIG QUERY / COMPUTE ENGINE / DBT CORE / TERRAFORM EXPERIMENT

</br>
</br>
This is an experiment of how to self host Prefect Orion server on Google Compute Engine. There's no auth here, so not a complete real life example, more of an inspiration. I don't know of an easy(ish) way to setup auth for that server, would be happy to hear any feedback on this.

</br>
</br>
With this setup you can build and apply a deployment from a github action trigger. Then run your deployment via Prefect UI or api. Agent picks it up, and is running it in a subprocess on the VM.

</br>
</br>
Both Prefect Orion and Prefect Agent are hosted here in the same VM with the help of tmux.

</br>
</br>
GCP Service account json api key was manually added here by ssh-ing into the VM and adding it there directly.

</br>
</br>
Happy if it helps anyone get started. Feedback / Comments welcome!
