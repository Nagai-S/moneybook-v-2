Chartkick.options = {
  donut: true,
  thousands: ',',
  suffix: '',
  library: {
    title: {
      align: 'center',
      verticalAlign: 'middle',
      style: {
        fontSize: '30px'
      }
    },
    chart: {
      backgroundColor: 'none',
      plotBorderWidth: 0,
      plotShadow: false
    },
    plotOptions: {
      pie: {
        dataLabels: {
          enabled: true,
          distance: -40, # ラベルの位置調節
          allowOverlap: false, # ラベル重なったら消す
          style: {
            color: 'black',
            textAlign: 'center',
            fontSize: '14px',
            textOutline: 0
          }
        },
        size: '100%',
        innerSize: '60%', # ドーナツグラフの中の円の大きさ
        borderWidth: 0
      }
    }
  }
}
