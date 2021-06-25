# coding: utf-8
# cython: boundscheck=True, wraparound=True
# cython: c_string_type=unicode, c_string_encoding=ascii

import numpy as np

cimport numpy as np
np.import_array()

cimport cython
from libc.stdlib cimport malloc, free
from libc.stdio cimport FILE, fopen, fclose
from htsengine cimport HTS_Engine
from htsengine cimport (
    HTS_Engine_initialize, HTS_Engine_load, HTS_Engine_clear, HTS_Engine_refresh,
    HTS_Engine_get_sampling_frequency, HTS_Engine_get_fperiod,
    HTS_Engine_set_speed, HTS_Engine_add_half_tone,
    HTS_Engine_synthesize_from_strings,
    HTS_Engine_get_generated_speech, HTS_Engine_get_nsamples,
    HTS_Engine_set_sampling_frequency,
    HTS_Engine_set_fperiod,
    HTS_Engine_set_volume,
    HTS_Engine_get_volume,
    HTS_Engine_set_msd_threshold,
    HTS_Engine_get_msd_threshold,
    HTS_Engine_set_gv_weight,
    HTS_Engine_get_gv_weight,
    HTS_Engine_set_audio_buff_size,
    HTS_Engine_get_audio_buff_size,
    HTS_Engine_set_stop_flag,
    HTS_Engine_get_stop_flag,
    HTS_Engine_set_phoneme_alignment_flag,
    HTS_Engine_set_alpha,
    HTS_Engine_get_alpha,
    HTS_Engine_set_beta,
    HTS_Engine_get_beta,
    HTS_Engine_set_duration_interpolation_weight,
    HTS_Engine_get_duration_interpolation_weight,
    HTS_Engine_set_parameter_interpolation_weight,
    HTS_Engine_get_parameter_interpolation_weight,
    HTS_Engine_set_gv_interpolation_weight,
    HTS_Engine_get_gv_interpolation_weight,
    HTS_Engine_get_total_state,
    HTS_Engine_set_state_mean,
    HTS_Engine_get_state_mean,
    HTS_Engine_get_state_duration,
    HTS_Engine_get_nvoices,
    HTS_Engine_get_nstream,
    HTS_Engine_get_nstate,
    HTS_Engine_get_fullcontext_label_version,
    HTS_Engine_get_total_frame,
    HTS_Engine_get_generated_parameter,
    HTS_Engine_generate_state_sequence_from_fn,
    HTS_Engine_generate_state_sequence_from_strings,
    HTS_Engine_generate_parameter_sequence,
    HTS_Engine_generate_sample_sequence,
    HTS_Engine_save_information,
    HTS_Engine_save_label,
    HTS_Engine_save_generated_parameter,
    HTS_Engine_save_generated_speech,
    HTS_Engine_save_riff
)

cdef class HTSEngine(object):
    """HTSEngine

    Args:
        voice (bytes): File path of htsvoice.
    """
    cdef HTS_Engine* engine

    def __cinit__(self, bytes voice=b"htsvoice/mei_normal.htsvoice"):
        self.engine = new HTS_Engine()

        HTS_Engine_initialize(self.engine)

        if self.load(voice) != 1:
          self.clear()
          raise RuntimeError("Failed to initalize HTS_Engine")

    def load(self, bytes voice):
        cdef char* voices = voice
        cdef char ret
        ret = HTS_Engine_load(self.engine, &voices, 1)
        return ret

    def get_sampling_frequency(self):
        """Get sampling frequency
        """
        return HTS_Engine_get_sampling_frequency(self.engine)

    def get_fperiod(self):
        """Get frame period"""
        return HTS_Engine_get_fperiod(self.engine)

    def set_speed(self, speed=1.0):
        """Set speed

        Args:
            speed (float): speed
        """
        HTS_Engine_set_speed(self.engine, speed)

    def add_half_tone(self, half_tone=0.0):
        """Additional half tone in log-f0

        Args:
            half_tone (float): additional half tone
        """
        HTS_Engine_add_half_tone(self.engine, half_tone)

    def synthesize(self, list labels):
        """Synthesize waveform from list of full-context labels

        Args:
            labels: full context labels

        Returns:
            np.ndarray: speech waveform
        """
        self.synthesize_from_strings(labels)
        x = self.get_generated_speech()
        self.refresh()
        return x

    def synthesize_from_strings(self, list labels):
        """Synthesize from strings"""
        cdef size_t num_lines = len(labels)
        cdef char **lines = <char**> malloc((num_lines + 1) * sizeof(char*))
        for n in range(len(labels)):
            lines[n] = <char*>labels[n]

        cdef char ret = HTS_Engine_synthesize_from_strings(self.engine, lines, num_lines)
        free(lines)
        if ret != 1:
            raise RuntimeError("Failed to run synthesize_from_strings")

    def get_generated_speech(self):
        """Get generated speech"""
        cdef size_t nsamples = HTS_Engine_get_nsamples(self.engine)
        cdef np.ndarray speech = np.zeros([nsamples], dtype=np.float64)
        cdef size_t index
        for index in range(nsamples):
            speech[index] = HTS_Engine_get_generated_speech(self.engine, index)
        return speech

    def get_fullcontext_label_format(self):
        """Get full-context label format"""
        return (<bytes>HTS_Engine_get_fullcontext_label_format(self.engine)).decode("utf-8")

    def refresh(self):
        HTS_Engine_refresh(self.engine)

    def clear(self):
        HTS_Engine_clear(self.engine)

    def __dealloc__(self):
        self.clear()
        del self.engine

    # 追加API ---- start
    def set_sampling_frequency(self, size_t i): HTS_Engine_set_sampling_frequency(self.engine, i)
    def set_fperiod(self, size_t i): HTS_Engine_set_fperiod(self.engine, i)
    def set_volume(self, double f): HTS_Engine_set_volume(self.engine, f)
    def get_volume(self): return HTS_Engine_get_volume(self.engine) # double
    def set_msd_threshold(self, size_t stream_index, double f): HTS_Engine_set_msd_threshold(self.engine, stream_index, f)
    def get_msd_threshold(self, size_t stream_index): return HTS_Engine_get_msd_threshold(self.engine, stream_index) # double
    def set_gv_weight(self, size_t stream_index, double f): HTS_Engine_set_gv_weight(self.engine, stream_index, f)
    def get_gv_weight(self, size_t stream_index): return HTS_Engine_get_gv_weight(self.engine, stream_index) # double
    def set_audio_buff_size(self, size_t i): HTS_Engine_set_audio_buff_size(self.engine, i)
    def get_audio_buff_size(self): return HTS_Engine_get_audio_buff_size(self.engine) # size_t
    def set_stop_flag(self, HTS_Boolean b): HTS_Engine_set_stop_flag(self.engine, b)
    def get_stop_flag(self): HTS_Engine_get_stop_flag(self.engine) # HTS_Boolean 
    def set_phoneme_alignment_flag(self, HTS_Boolean b): HTS_Engine_set_phoneme_alignment_flag(self.engine, b)
    def set_alpha(self, double f): HTS_Engine_set_alpha(self.engine, f)
    def get_alpha(self): return HTS_Engine_get_alpha(self.engine) # double 
    def set_beta(self, double f): HTS_Engine_set_beta(self.engine, f)
    def get_beta(self): return HTS_Engine_get_beta(self.engine) # double 
    def set_duration_interpolation_weight(self, size_t voice_index, double f): HTS_Engine_set_duration_interpolation_weight(self.engine, voice_index, f)
    def get_duration_interpolation_weight(self, size_t voice_index): return HTS_Engine_get_duration_interpolation_weight(self.engine, voice_index) # double 
    def set_parameter_interpolation_weight(self, size_t voice_index, size_t stream_index, double f): HTS_Engine_set_parameter_interpolation_weight(self.engine, voice_index, stream_index, f)
    def get_parameter_interpolation_weight(self, size_t voice_index, size_t stream_index): return HTS_Engine_get_parameter_interpolation_weight(self.engine, voice_index, stream_index)  # double 
    def set_gv_interpolation_weight(self, size_t voice_index, size_t stream_index, double f): HTS_Engine_set_gv_interpolation_weight(self.engine, voice_index, stream_index, f)
    def get_gv_interpolation_weight(self, size_t voice_index, size_t stream_index): return HTS_Engine_get_gv_interpolation_weight(self.engine, voice_index, stream_index) # double 
    def get_total_state(self): return HTS_Engine_get_total_state(self.engine) # size_t 
    def set_state_mean(self, size_t stream_index, size_t state_index, size_t vector_index, double f): HTS_Engine_set_state_mean(self.engine, stream_index, state_index, vector_index, f)
    def get_state_mean(self, size_t stream_index, size_t state_index, size_t vector_index): return HTS_Engine_get_state_mean(self.engine, stream_index, state_index, vector_index) # double 
    def get_state_duration(self, size_t state_index): HTS_Engine_get_state_duration(self.engine, state_index) # size_t 
    def get_nvoices(self): return HTS_Engine_get_nvoices(self.engine) # size_t 
    def get_nstream(self): return HTS_Engine_get_nstream(self.engine) # size_t 
    def get_nstate(self): return HTS_Engine_get_nstate(self.engine) # size_t 
    def get_fullcontext_label_version(self): return HTS_Engine_get_fullcontext_label_version(self.engine) # const char *
    def get_total_frame(self): return HTS_Engine_get_total_frame(self.engine) # size_t 
    def get_generated_parameter(self, size_t stream_index, size_t frame_index, size_t vector_index): HTS_Engine_get_generated_parameter(self.engine, stream_index, frame_index, vector_index) # double 
    def generate_state_sequence_from_fn(self, const char *fn): return HTS_Engine_generate_state_sequence_from_fn(self.engine, fn) # HTS_Boolean 
#    def generate_state_sequence_from_strings(self, char **lines, size_t num_lines): return HTS_Engine_generate_state_sequence_from_strings(self.engine, lines, num_lines) # HTS_Boolean 
    def generate_state_sequence_from_strings(self, lines, size_t num_lines):
        cdef char** c_lines
        c_lines = <char**>malloc(len(lines) * sizeof(char*))
        if c_lines is NULL: raise MemoryError()
        for i in range(len(lines)):
            lines[i] = lines[i].encode()
            c_lines[i] = lines[i]
        res = HTS_Engine_generate_state_sequence_from_strings(self.engine, c_lines, num_lines) # HTS_Boolean 
        free(c_lines)
        return res
    def generate_parameter_sequence(self): return HTS_Engine_generate_parameter_sequence(self.engine) # HTS_Boolean 
    def generate_sample_sequence(self): return HTS_Engine_generate_sample_sequence(self.engine) # HTS_Boolean 
#    def save_information(self, FILE * fp):
    def save_information(self, bytes path):
        cdef FILE* file_ptr
        file_ptr = fopen(path, 'wb')
        if NULL != file_ptr:
            HTS_Engine_save_information(self.engine, file_ptr)
            fclose(file_ptr)
        else: print(f'ERROR: Not open file: {path}')
#    def save_label(self, FILE * fp): HTS_Engine_save_label(self.engine, fp)
    def save_label(self, bytes path):
        cdef FILE* file_ptr
        file_ptr = fopen(path, 'wb')
        if NULL != file_ptr:
            HTS_Engine_save_label(self.engine, file_ptr)
            fclose(file_ptr)
        else: print(f'ERROR: Not open file: {path}')
#    def save_generated_parameter(self, size_t stream_index, FILE * fp): HTS_Engine_save_generated_parameter(self.engine, stream_index, fp)
    def save_generated_parameter(self, size_t stream_index, bytes path):
        cdef FILE* file_ptr
        file_ptr = fopen(path, 'wb')
        if NULL != file_ptr:
            HTS_Engine_save_generated_parameter(self.engine, stream_index, file_ptr)
            fclose(file_ptr)
        else: print(f'ERROR: Not open file: {path}')
#    def save_generated_speech(self, FILE * fp): HTS_Engine_save_generated_speech(self.engine, fp)
    def save_generated_speech(self, bytes path):
        cdef FILE* file_ptr
        file_ptr = fopen(path, 'wb')
        if NULL != file_ptr:
            HTS_Engine_save_generated_speech(self.engine, file_ptr)
            fclose(file_ptr)
        else: print(f'ERROR: Not open file: {path}')
#    def save_riff(self, FILE * fp): HTS_Engine_save_riff(self.engine, fp)
    def save_riff(self, bytes path):
        cdef FILE* file_ptr
        file_ptr = fopen(path, 'wb')
        if NULL != file_ptr:
            HTS_Engine_save_riff(self.engine, file_ptr)
            fclose(file_ptr)
        else: print(f'ERROR: Not open file: {path}')
    # 追加API ---- end

