// JS com jQuery
$(document).ready(function() {
  let chartsCreated = false;

  function createCharts(data) {
    const ctxBar = document.getElementById('myBarChart').getContext('2d');
    const labels = data.product_selected;
    const barData = {
      labels: labels,
      datasets: [{
        label: 'Produtos mais populares por venda (' + data.text + ')',
        data: data.quantity_of_sales,
        barPercentage: 1,
      }]
    };

    new Chart(ctxBar, {
      type: 'bar',
      data: barData,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {
            grid: {},
            ticks: {
              font: {
                size: 20
              }
            }
          },
          y: {
            suggestedMin: 0,
            suggestedMax: 20,
            color: 'white',
            grid: {},
            ticks: {
              font: {
                size: 20
              }
            }
          }
        },
        plugins: {
          legend: {
            labels: {
              font: {
                size: 20
              }
            }
          }
        }
      }
    });

    const ctxLine = document.getElementById('myLineChart').getContext('2d');
    const lineLabels = data.all_dates_last_days.map(function(date) {
      return date === data.current_date ? date + ' (Hoje)' : date;
    });
    const lineData = {
      labels: lineLabels,
      datasets: [{
        label: 'Quantidade de vendas dos últimos 7 dias ' + data.total_text,
        data: data.data,
        fill: false,
        borderColor: 'cyan',
        tension: 0.1,
        borderWidth: 5,
        pointHitRadius: 20,
        pointBackgroundColor: 'black'
      }]
    };

    new Chart(ctxLine, {
      type: 'line',
      data: lineData,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {
            color: 'white',
            grid: {
              color: 'white'
            },
            ticks: {
              color: 'white',
              font: {
                size: 20
              }
            }
          },
          y: {
            suggestedMin: 0,
            suggestedMax: 50,
            color: 'white',
            grid: {
              color: 'white'
            },
            ticks: {
              color: 'white',
              font: {
                size: 20
              }
            }
          }
        },
        plugins: {
          legend: {
            labels: {
              color: 'white',
              font: {
                size: 20
              }
            }
          }
        }
      }
    });

    chartsCreated = true;
  }

  if (!chartsCreated) {
    $.ajax({
      url: '/datas_from_controller',
      dataType: 'json',
      success: function(data) {
        createCharts(data);
      },
      error: function(xhr, status, error) {
        console.error('Erro na requisição AJAX:', error);
      }
    });
  }
});
