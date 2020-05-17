import React, { useState } from 'react';
import AwesomeSlider from 'react-awesome-slider';
import 'react-awesome-slider/dist/styles.css';
import './promos.css'
import { Card, CardActionArea, Grid, Tooltip, Typography, makeStyles } from '@material-ui/core';
import AddCircleIcon from '@material-ui/icons/AddCircle';
import Popup from "reactjs-popup";
import './popup.css';
import axios from 'axios';

const useStyles = makeStyles(theme => ({
  card: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    textAlign: 'center',
    paddingLeft: 0,
    paddingRight: 0,
    paddingTop: theme.spacing(0),
    height: 150
  },
  grid: {
    display: 'flex',
    flexDirection: 'column',
    paddingTop: 50,
    alignItem:'center', 
    justify: 'center',
    textAlign: 'center',
    height: 150
  },
  popup: {
    height: 200,
    width: 200,
  }
}));

export default function NewPromos() {
  const styles = useStyles();
  
  const [data, setData] = useState(null);
  
  const onImageChange = event => {
   if (event.target.files && event.target.files[0]) {
     let reader = new FileReader();
     let file = event.target.files[0];
     reader.onloadend = () => {
       setData({
         ...data,
         imagePreview: reader.result,
         file: file
       });
     };
     reader.readAsDataURL(file);
   }
 };
 
 const submitForm = form => {
    form.preventDefault();
    const formData = new FormData();
    formData.append("image", data.file);
    
    const config = {
      headers: {
        "content-type": "multipart/form-data"
      }
    };
    axios
      .post('https://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/store/' + '', formData, config)
      .then(response => {
        alert('The file is successfully uploaded');
      })
      .catch(error => {});
  };
  
  return (
    <Card >
      <Popup
        trigger={ 
          <CardActionArea>
            <Grid className={styles.grid}>
              <Grid item>
                <Typography>
                  Add new Banner
                </Typography>
              </Grid>
              <Grid item>
                <AddCircleIcon/>
              </Grid>
            </Grid>
          </CardActionArea>
      } modal >
        <Card className={styles.popup}>
        <Typography>
          Choose Banner Image
        </Typography>
        <form onSubmit={form => submitForm(form)}>
          <input type='file' name='image' multiple onChange={onImageChange} />
          <button type='submit'> Upload Image </button>
        </form>
        </Card>
      </Popup>
    </Card>
  );
}